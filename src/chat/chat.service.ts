import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ChatEntity } from './entity/chat.entity';
import { UserEntity } from '@/user/entity/user.entity';
import { Repository } from 'typeorm';
import {
  GetMyChatsResponse,
  GetSingleChatResponse,
  FormattedChat,
} from './types/chat-response.interface';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(ChatEntity)
    private readonly chatRepository: Repository<ChatEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async getMyChats(userId: string): Promise<GetMyChatsResponse> {
    const chats = await this.chatRepository
      .createQueryBuilder('chat')
      .leftJoinAndSelect('chat.participants', 'participant')
      .leftJoinAndSelect('participant.profile', 'participantProfile')
      .leftJoinAndSelect('chat.messages', 'message')
      .leftJoinAndSelect('message.sender', 'sender')
      .leftJoinAndSelect('sender.profile', 'senderProfile')
      .where('participant.id = :userId', { userId })
      .orderBy('message.createdAt', 'ASC')
      .getMany();

    if (chats.length === 0) {
      return { chats: [], chatsCount: 0 };
    }

    const formattedChats = this.formatChatData(chats);

    // Додаємо інформацію про співрозмовника для кожного чату
    const chatWith = formattedChats.map((chat) => {
      const chatWith = chat.participants.filter((p) => p.id !== userId);
      return {
        ...chat,
        chatWith: chatWith[0] || null,
      };
    });

    return {
      chats: [...chatWith],
      chatsCount: chats.length,
    };
  }
  async getSingleChat(chatId: string, userId: string): Promise<GetSingleChatResponse> {
    const currentChat = await this.chatRepository.findOne({
      where: { id: chatId },
      relations: [
        'participants',
        'participants.profile',
        'messages',
        'messages.sender',
        'messages.sender.profile',
      ],
    });

    const chatsCount = await this.chatRepository.countBy({ id: chatId });

    if (!currentChat) {
      throw new HttpException('Chat not found', HttpStatus.NOT_FOUND);
    }

    const isParticipant = currentChat.participants.some((p) => p.id === userId);
    if (!isParticipant) {
      throw new HttpException(
        'You are not a participant of this chat',
        HttpStatus.FORBIDDEN,
      );
    }

    const formattedChats = this.formatChatData([currentChat]);
    const formattedChat = formattedChats[0];

    const chatWith = formattedChat.participants.filter((p) => p.id !== userId);

    if (chatWith.length === 0) {
      throw new HttpException(
        'Chat participant not found',
        HttpStatus.NOT_FOUND,
      );
    }

    return {
      chats: {
        ...formattedChat,
        chatWith: chatWith[0],
      },
      chatsCount: chatsCount,
    };
  }

  async createChat(participantId: string, user: UserEntity): Promise<ChatEntity> {
    if (participantId === user.id) {
      throw new HttpException(
        'Cannot create chat with yourself',
        HttpStatus.BAD_REQUEST,
      );
    }

    const participant = await this.userRepository.findOne({
      where: { id: participantId },
    });
    if (!participant) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const existingChat = await this.chatRepository
      .createQueryBuilder('chat')
      .innerJoin('chat.participants', 'participant')
      .where('participant.id IN (:...userIds)', {
        userIds: [user.id, participantId],
      })
      .groupBy('chat.id')
      .having('COUNT(DISTINCT participant.id) = 2')
      .getOne();

    if (existingChat) {
      throw new HttpException('Chat already exists', HttpStatus.BAD_REQUEST);
    }

    const newChat = this.chatRepository.create({
      participants: [user, participant],
    });

    return this.chatRepository.save(newChat);
  }

  private formatChatData(data: ChatEntity[]): FormattedChat[] {
    const filtredData = data.map((chat) => {
      const p = chat.participants.map((p) => {
        return {
          email: p.email,
          id: p.id,
          username: p.username,
          profile: {
            id: p?.profile?.id || '',
            firstName: p?.profile?.avatar_url || '',
            lastName: p?.profile?.first_name || '',
            avatar: p?.profile?.last_name || '',
          },
        };
      });
      return {
        id: chat.id,
        participants: p,
        messages: chat.messages,
      };
    });

    return filtredData;
  }
}
