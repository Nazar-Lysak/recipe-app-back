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

    // Перевірка чи користувач є учасником чату
    const participant = chat.participants.find((p) => p.id === userId);

    if (!participant) {
      throw new HttpException(
        'You are not a participant of this chat',
        HttpStatus.FORBIDDEN,
      );
    }

    delete participant.password;

    const message = this.messageRepository.create({
      chat: chat, // Передаємо повний об'єкт чату
      sender: participant,
      content: createMessageDto.content,
    });

    const savedMessage = await this.messageRepository.save(message);

    // Повертаємо чисте повідомлення без об'єкта chat
    const { chat: _, ...messageWithoutChat } = savedMessage;

    return {
      ...messageWithoutChat,
      sender: participant,
      chatId: chatId,
    };
  }
}
