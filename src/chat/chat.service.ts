import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ChatEntity } from './entity/chat.entity';
import { UserEntity } from '@/user/entity/user.entity';
import { Repository } from 'typeorm';
import { CreateChatDto } from './dto/cteateChat.dto';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(ChatEntity)
    private readonly chatRepository: Repository<ChatEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async getMyChats(userId: string): Promise<any> {
    



    return {message: "get my chats"};
  }

  async getSingleChat(chatId: string): Promise<any> {



    return {message: "get single chat"};
  }

  async createChat(dto: CreateChatDto, userId: string): Promise<any> {
    


    return {message: "create chat"};
  }
}
