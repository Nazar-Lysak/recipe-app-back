import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ChatEntity } from './entity/chat.entity';
import { UserEntity } from '@/user/entity/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(ChatEntity)
    private readonly chatRepository: Repository<ChatEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async getMyChats(userId: string): Promise<any> {
    // Спочатку знаходимо ID чатів користувача
    const chatIds = await this.chatRepository
      .createQueryBuilder('chat')
      .leftJoin('chat.participants', 'participant')
      .where('participant.id = :userId', { userId })
      .select('chat.id')
      .getRawMany();

    if (chatIds.length === 0) {
      return [];
    }

    const ids = chatIds.map((c) => c.chat_id);

    // Завантажуємо повні дані чатів
    const chats = await this.chatRepository.find({
      where: ids.map((id) => ({ id })),
      relations: [
        'participants',
        'participants.profile',
        'messages',
        'messages.sender',
        'messages.sender.profile',
      ],
      order: {
        messages: {
          createdAt: 'ASC',
        },
      },
    });

    return this.formatChatData(chats);
  }

  async getSingleChat(chatId: string, userId: string): Promise<any> {
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

    const formattedChat = this.formatChatData([currentChat]);

    const chatWith = formattedChat.participants.filter((p) => p.id !== userId);

    if (chatWith.length === 0) {
      throw new HttpException(
        'Chat participant not found',
        HttpStatus.NOT_FOUND,
      );
    }

    return {
      ...formattedChat,
      chatWith: chatWith[0],
    };
  }

  async createChat(participantId: string, user: UserEntity): Promise<any> {
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

  private formatChatData(data: ChatEntity[]): any {
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

    return filtredData[0];
  }
}
