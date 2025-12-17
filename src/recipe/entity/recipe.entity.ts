import { CategoryEntity } from '@/category/entity/category.entity';
import { UserEntity } from '@/user/entity/user.entity';
import { UserProfileEntity } from '@/user/entity/user-profile.entity';
import {
  BeforeUpdate,
  Column,
  Entity,
  JoinColumn,
  ManyToMany,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity('recipes')
export class RecipeEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  name: string;

  @Column({ default: '' })
  description: string;

  @Column()
  time: number;

  @Column({ nullable: true })
  image: string;

  @Column({ nullable: true })
  video: string;

  // @Column({ type: 'float', default: 0 })
  // rating: number;

  @Column({ default: 0 })
  favouriteCount: number;

  @Column('text', { array: true })
  ingredients: string[];

  @Column('text', { array: true })
  steps: string[];

  @Column()
  authorId: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updatedAt: Date;

  @ManyToOne(() => UserEntity, (user) => user.recipes)
  author: UserEntity;

  @ManyToOne(() => CategoryEntity)
  @JoinColumn({ name: 'categoryId' })
  category: CategoryEntity;

  @Column('text', { array: true, default: '{}' })
  likedByUserIds: string[];

  @BeforeUpdate()
  updateTimestamp() {
    this.updatedAt = new Date();
  }
}
