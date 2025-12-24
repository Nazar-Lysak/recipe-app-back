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

    async getAllChats(): Promise<ChatEntity[]> {
        return this.chatRepository.find({relations: ['participants', 'messages']});
    }


    async getMyChats(chatId: string): Promise<ChatEntity[]> {
        
        const chat = await this.chatRepository.find({where: {id: chatId}, relations: ['participants', 'messages']});

        if(!chat){
            throw new HttpException('Chat not found', HttpStatus.NOT_FOUND);
        }

        return chat;
    }

    async createChat(dto: CreateChatDto, userId: string): Promise<ChatEntity> {

        if(userId === dto.participantId){
            throw new HttpException('Cannot create chat with yourself', HttpStatus.BAD_REQUEST);
        }

        const existingChat = await this.chatRepository
            .createQueryBuilder('chat')
            .innerJoin('chat.participants', 'participant')
            .where('participant.id IN (:...userIds)', { userIds: [userId, dto.participantId] })
            .groupBy('chat.id')
            .having('COUNT(DISTINCT participant.id) = 2')
            .getOne();
        

        if (existingChat) {
            throw new HttpException('Chat already exists', HttpStatus.BAD_REQUEST);
        }

        const currentUser = await this.userRepository.findOne({where: {id: userId}});
        const participant = await this.userRepository.findOne({where: {id: dto.participantId}});

        if (!currentUser) {
            throw new HttpException('Current user not found', HttpStatus.NOT_FOUND);
        }

        if (!participant) {
            throw new HttpException('Participant not found', HttpStatus.NOT_FOUND);
        }

        delete currentUser.password;
        delete participant.password;

        const newChat = this.chatRepository.create({
            participants: [currentUser, participant]
        });

        return this.chatRepository.save(newChat);
    }
}
