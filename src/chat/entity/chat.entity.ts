import { UserEntity } from '@/user/entity/user.entity';
import {
  Entity,
  JoinTable,
  ManyToMany,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { MessageEntity } from '../../message/entity/message.entity';

@Entity('chats')
export class ChatEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToMany(() => UserEntity)
  @JoinTable()
  participants: UserEntity[];

  @OneToMany(() => MessageEntity, (m) => m.chat)
  messages: MessageEntity[];
}
