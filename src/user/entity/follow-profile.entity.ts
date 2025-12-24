import { Entity, PrimaryColumn, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';
import { UserEntity } from './user.entity';

@Entity('follow_profiles')
export class FollowProfileEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @PrimaryColumn('uuid')
  followerId: string;

  @PrimaryColumn('uuid')
  followingId: string;

  @ManyToOne(() => UserEntity, (user) => user.followers)
  @JoinColumn({ name: 'followingId' })
  following: UserEntity;
}
