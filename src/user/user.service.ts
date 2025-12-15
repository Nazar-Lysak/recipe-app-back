import { compare } from 'bcrypt';
import { sign } from 'jsonwebtoken';
import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/createUser.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from './entity/user.entity';
import { Repository } from 'typeorm';
import { env } from 'process';
import { loginUserDto } from './dto/loginUser.dto';
import { UserProfile } from './entity/user-profile.entity';
import { UpdateUserDto } from './dto/updateUser.dto';
import { nanoid } from 'nanoid';
import { AvatarGeneratorService } from '@/avatar-generator/avatar-generator.service';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(UserEntity)
    private userRepository: Repository<UserEntity>,
    @InjectRepository(UserProfile)
    private userProfileRepository: Repository<UserProfile>,
    private readonly avatarGeneratorService: AvatarGeneratorService,
  ) {}

  async getAllUsers() {
    const users = await this.userRepository.find();
    const createResult = users.map((user) => {
      const { password, ...result } = user;
      return result;
    });
    return { users: createResult };
  }

  async getCurrentUser(user: any) {
    if (!user) {
      throw new HttpException(
        'No authenticated user found',
        HttpStatus.UNAUTHORIZED,
      );
    }

    const userProfile = await this.userProfileRepository.findOne({
      where: { user: { id: user.id } },
    });

    delete user.password;

    return { profile: { ...user, ...userProfile } };
  }

  async getUserById(id: string): Promise<any> {
    const user = await this.userRepository.findOne({
      where: { id },
    });

    if (!user) {
      throw new HttpException(
        `User with id ${id} not found`,
        HttpStatus.NOT_FOUND,
      );
    }

    const userProfile = await this.userProfileRepository.findOne({
      where: { user: { id: user.id } },
    });

    delete user.password;
    delete userProfile?.updated_at;
    delete userProfile?.theme;
    delete userProfile?.language;

    Object.assign(user, userProfile);

    console.log(user);

    return user;
  }

  async updateUser(user: any, updateUserDto: UpdateUserDto) {
    if (!user) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    delete user.password;

    const currentUserProfile = await this.userProfileRepository.findOne({
      where: { user: { id: user.id } },
    });

    if (!currentUserProfile) {
      throw new HttpException('User profile not found', HttpStatus.NOT_FOUND);
    }

    Object.assign(currentUserProfile, updateUserDto);

    return await this.userProfileRepository.save(currentUserProfile);
  }

  async createUser(createUserDto: CreateUserDto): Promise<any> {
    const { email, username } = createUserDto;

    const emailExists = await this.userRepository.findOne({
      where: { email },
    });
    if (emailExists) {
      throw new HttpException(
        'User with this email already exists',
        HttpStatus.BAD_REQUEST,
      );
    }

    const usernameExists = await this.userRepository.findOne({
      where: { username },
    });
    if (usernameExists) {
      throw new HttpException(
        'User with this username already exists',
        HttpStatus.BAD_REQUEST,
      );
    }

    const newUser = new UserEntity();
    Object.assign(newUser, createUserDto);

    const savedUser = await this.userRepository.save(newUser);
    const randomAvatar = this.avatarGeneratorService.generateAvatarUrl();

    // Create user profile
    const newProfile = new UserProfile();
    newProfile.user = savedUser;
    newProfile.avatar_url = randomAvatar;
    await this.userProfileRepository.save(newProfile);

    delete savedUser.password;
    return this.generateUserResponse(savedUser);
  }

  async loginUser(loginUserDto: loginUserDto): Promise<any> {
    const { email, password } = loginUserDto;

    const user = await this.userRepository.findOne({ where: { email } });
    if (!user) {
      throw new HttpException('Wrong email or password', HttpStatus.NOT_FOUND);
    }

    const isPasswordValid = await compare(password, user.password);

    if (!isPasswordValid) {
      throw new HttpException('Invalid credentials', HttpStatus.UNAUTHORIZED);
    }

    delete user.password;

    return this.generateUserResponse(user);
  }

  async forgotPassword(email: string): Promise<any> {
    const user = await this.userRepository.findOne({ where: { email } });
    if (user) {
      const resetToken = nanoid(64);
      console.log(resetToken);
    }

    return {
      message:
        'A password reset link has been sent to your email address if it exists in our system.',
    };
  }

  findById(id: string): Promise<any> {
    const user = this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new HttpException(
        `User with id ${id} not found`,
        HttpStatus.NOT_FOUND,
      );
    }

    return user;
  }

  generateToken(user: UserEntity): string {
    const token = sign(
      {
        id: user.id,
        email: user.email,
        username: user.username,
      },
      process.env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRATION_TIME },
    );

    return token;
  }

  generateUserResponse(user: UserEntity) {
    if (!user.id) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }
    return {
      user: {
        ...user,
        token: this.generateToken(user),
      },
    };
  }
}
