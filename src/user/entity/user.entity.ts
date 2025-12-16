import * as bcrypt from 'bcrypt';
import {
  BeforeInsert,
  BeforeUpdate,
  Column,
  Entity,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { UserProfileEntity } from './user-profile.entity';
import { RecipeEntity } from '@/recipe/entity/recipe.entity';

@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ unique: true })
  username: string;

  @Column()
  password?: string;

  @OneToOne(() => UserProfileEntity, (profile) => profile.user)
  profile: UserProfileEntity;

  @OneToMany(() => RecipeEntity, (recipe) => recipe.author)
  recipes: RecipeEntity[];

  @BeforeInsert()
  @BeforeUpdate()
  async hashPassword() {
    if (this.password) {
      const saltOrRounds = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, saltOrRounds);
    }
  }
}
