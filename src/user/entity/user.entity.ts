import * as bcrypt from 'bcrypt';
import {
  BeforeInsert,
  BeforeUpdate,
  Column,
  Entity,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { UserProfile } from './user-profile.entity';

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

  @OneToOne(() => UserProfile, (profile) => profile.user)
  profile: UserProfile;

  @BeforeInsert()
  @BeforeUpdate()
  async hashPassword() {
    if (this.password) {
      const saltOrRounds = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, saltOrRounds);
    }
  }
}
