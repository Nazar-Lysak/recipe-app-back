import { CategoryEntity } from '../../category/entity/category.entity';
import { ReviewEntity } from '../../review/entity/review.entity';
import { UserEntity } from '../../user/entity/user.entity';
import {
  BeforeUpdate,
  Column,
  Entity,
  JoinColumn,
  ManyToMany,
  ManyToOne,
  OneToMany,
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

  @Column({ type: 'float', default: 0 })
  averageRating: number;

  @Column({ default: 0 })
  reviewsCount: number;

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

  @OneToMany(() => ReviewEntity, (review) => review.recipe)
  reviews: ReviewEntity[];

  @Column('text', { array: true, default: '{}' })
  likedByUserIds: string[];

  @BeforeUpdate()
  updateTimestamp() {
    this.updatedAt = new Date();
  }
}
