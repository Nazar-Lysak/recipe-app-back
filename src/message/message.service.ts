import { ChatEntity } from '@/chat/entity/chat.entity';
import { UserEntity } from '@/user/entity/user.entity';
import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MessageEntity } from './entity/message.entity';
import { CreateMessageDto } from './dto/createMessage.dto';

@Injectable()
export class MessageService {
  constructor(
    @InjectRepository(ChatEntity)
    private readonly chatRepository: Repository<ChatEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(MessageEntity)
    private readonly messageRepository: Repository<MessageEntity>,
  ) {}

  async createMessage(
    chatId: string,
    createMessageDto: CreateMessageDto,
    userId: string,
  ) {
    const chat = await this.chatRepository.findOne({
      where: { id: chatId },
      relations: ['participants'],
    });

    if (!chat) {
      throw new HttpException('Chat not found', HttpStatus.NOT_FOUND);
    }

    const isParticipant = chat.participants.some(
      (participant) => participant.id === userId,
    );

    if (!isParticipant) {
      throw new HttpException('Access denied', HttpStatus.FORBIDDEN);
    }

    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (!user) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const newMessage = this.messageRepository.create({
      chat,
      sender: user,
      content: createMessageDto.content,
    });

    return await this.messageRepository.save(newMessage);
  }

  async markMessagesAsRead(chatId: string, userId: string): Promise<void> {
    const chat = await this.chatRepository.findOne({
      where: { id: chatId },
      relations: ['participants', 'messages', 'messages.sender'],
    });

    if (!chat) {
      throw new HttpException('Chat not found', HttpStatus.NOT_FOUND);
    }

    const isParticipant = chat.participants.some(
      (participant) => participant.id === userId,
    );

    if (!isParticipant) {
      throw new HttpException('Access denied', HttpStatus.FORBIDDEN);
    }

    const unreadMessages = chat.messages.filter(
      (message) => message.sender.id !== userId && !message.isRead,
    );

    for (const message of unreadMessages) {
      message.isRead = true;
      await this.messageRepository.save(message);
    }
  }
}
