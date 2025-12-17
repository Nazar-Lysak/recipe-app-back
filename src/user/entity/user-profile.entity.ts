import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  JoinColumn,
  ManyToMany,
  JoinTable,
} from 'typeorm';
import { UserEntity } from './user.entity';
import { RecipeEntity } from '@/recipe/entity/recipe.entity';

@Entity('user_profiles')
export class UserProfileEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: true })
  first_name: string;

  @Column({ nullable: true })
  last_name: string;

  @Column({ type: 'text', nullable: true })
  bio: string;

  @Column({ nullable: true })
  avatar_url: string;

  @Column({ nullable: true })
  banner_url: string;

  @Column({ nullable: true })
  location: string;

  @Column({ nullable: true })
  website: string;

  @Column({ nullable: true })
  instagram: string;

  @Column({ nullable: true })
  tiktok: string;

  @Column({ nullable: true })
  facebook: string;

  @Column({ nullable: true })
  youtube: string;

  @Column({ default: 0 })
  followers_count: number;

  @Column({ default: 0 })
  following_count: number;

  @Column({ default: 0 })
  recipes_count: number;

  @Column({ default: 0 })
  likes_received: number;

  // @Column({ type: 'float', default: 0 })
  // rating: number;

  @Column({ default: false })
  is_private: boolean;

  @Column({ default: 'en' })
  language?: string;

  @Column({ default: 'light' })
  theme?: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @Column({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  updated_at?: Date;

  @OneToOne(() => UserEntity, (user) => user.profile)
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column('text', { array: true, default: '{}' })
  liked_recipes: string[];
}
