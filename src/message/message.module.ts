import { Module } from '@nestjs/common';
import { MessageService } from './message.service';
import { MessageController } from './message.controller';
import { UserEntity } from '@/user/entity/user.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChatEntity } from '@/chat/entity/chat.entity';
import { MessageEntity } from './entity/message.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ChatEntity, UserEntity, MessageEntity])],
  providers: [MessageService],
  controllers: [MessageController],
})
export class MessageModule {}
