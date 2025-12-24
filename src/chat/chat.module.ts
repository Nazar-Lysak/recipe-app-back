import { Module } from '@nestjs/common';
import { ChatService } from './chat.service';
import { ChatController } from './chat.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChatEntity } from './entity/chat.entity';
import { UserEntity } from '@/user/entity/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ChatEntity, UserEntity])],
  providers: [ChatService],
  controllers: [ChatController],
})
export class ChatModule {}
