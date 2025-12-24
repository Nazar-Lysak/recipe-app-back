import { compare } from 'bcrypt';
import { sign } from 'jsonwebtoken';
import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/createUser.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from './entity/user.entity';
import { Repository } from 'typeorm';
import { env } from 'process';
import { loginUserDto } from './dto/loginUser.dto';
import { UserProfileEntity } from './entity/user-profile.entity';
import { UpdateUserDto } from './dto/updateUser.dto';
import { nanoid } from 'nanoid';
import { AvatarGeneratorService } from '@/avatar-generator/avatar-generator.service';
import { FollowProfileEntity } from './entity/follow-profile.entity';
import { CloudinaryService } from '@/cloudinary/cloudinary.service';
import { CLOUDINARY_DIR } from '@/config/couldinary.config';
import { ChangePasswordDto } from './dto/changePassword.dto';
import { MailService } from '@/mail/mail.service';
import { ResetPasswordEntity } from './entity/reset-password.entity';
import { RestorePasswordDto } from './dto/restorePassword.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(UserEntity)
    private userRepository: Repository<UserEntity>,
    @InjectRepository(UserProfileEntity)
    private userProfileRepository: Repository<UserProfileEntity>,
    @InjectRepository(FollowProfileEntity)
    private followProfileRepository: Repository<FollowProfileEntity>,
    @InjectRepository(ResetPasswordEntity)
    private resetPasswordRepository: Repository<ResetPasswordEntity>,
    private readonly avatarGeneratorService: AvatarGeneratorService,
    private readonly cloudinaryService: CloudinaryService,
    private readonly mailService: MailService,
  ) {}

  async getAllUsers() {
    const users = await this.userRepository
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.profile', 'profile', 'follow_profile')
      .getMany();
      
    const createResult = users.map((user) => {
      const { password, ...result } = user;
      return result;
    });
    return { users: createResult };
  }

  async getAllProfiles(query): Promise<any> {
    const queryBuilder = this.userProfileRepository
      .createQueryBuilder('profile')
      .leftJoinAndSelect('profile.user', 'user');

    if(query.date) {
      queryBuilder.orderBy('profile.created_at', 'DESC');
    } else if (query.top) {
      queryBuilder.orderBy('profile.likes_received', 'DESC');
    }

    if (query.offset) {
      queryBuilder.skip(parseInt(query.offset));
    }

    if (query.limit) {
      queryBuilder.take(parseInt(query.limit));
    }

    const profilesList = await queryBuilder.getMany();
    
    const profiles = await Promise.all(
      profilesList.map(async (profile) => {
        const followers = await this.followProfileRepository.find({
          where: { followingId: profile.user.id },
        });
        
        if (profile.user) {
          delete profile.user.password;
        }
        
        return {
          ...profile,
          followers,
        };
      })
    );

    return { profiles };
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

    return { ...user, ...userProfile };
  }

  async followUser(currentUser: any, id: string) {
    if (currentUser.id === id) {
      throw new HttpException(
        'You cannot follow yourself',
        HttpStatus.BAD_REQUEST,
      );
    }

    const followerProfile = await this.userProfileRepository.findOne({
      where: { user: { id: currentUser.id } },
    });

    if (!followerProfile) {
      throw new HttpException(
        'Follower profile not found',
        HttpStatus.NOT_FOUND,
      );
    }

    const followingProfile = await this.userProfileRepository.findOne({
      where: { user: { id } },
    });

    if (!followingProfile) {
      throw new HttpException(
        'Following profile not found',
        HttpStatus.NOT_FOUND,
      );
    }

    const existingFollow = await this.followProfileRepository.findOne({
      where: {
        followerId: currentUser.id,
        followingId: id,
      },
    });

    if (existingFollow) {
      throw new HttpException(
        'You are already following this user',
        HttpStatus.BAD_REQUEST,
      );
    }

    const followProfile = new FollowProfileEntity();
    Object.assign(followProfile, {
      followerId: currentUser.id,
      followingId: id,
    });

    followingProfile.followers_count++;
    followerProfile.following_count++;

    await this.userProfileRepository.save(followingProfile);
    await this.userProfileRepository.save(followerProfile);
    await this.followProfileRepository.save(followProfile);

    return { message: 'Successfully followed the user' };
  }

  async unfollowUser(currentUser: any, id: string) {
    const followerProfile = await this.userProfileRepository.findOne({
      where: { user: { id: currentUser.id } },
    });

    if (!followerProfile) {
      throw new HttpException(
        'Follower profile not found',
        HttpStatus.NOT_FOUND,
      );
    }

    const followingProfile = await this.userProfileRepository.findOne({
      where: { user: { id } },
    });

    if (!followingProfile) {
      throw new HttpException(
        'Following profile not found',
        HttpStatus.NOT_FOUND,
      );
    }

    const existingFollow = await this.followProfileRepository.findOne({
      where: {
        followerId: currentUser.id,
        followingId: id,
      },
    });

    if (!existingFollow) {
      throw new HttpException(
        'You are not following this user',
        HttpStatus.BAD_REQUEST,
      );
    }

    followingProfile.followers_count--;
    followerProfile.following_count--;

    await this.userProfileRepository.save(followingProfile);
    await this.userProfileRepository.save(followerProfile);
    await this.followProfileRepository.remove(existingFollow);

    return { message: 'Successfully unfollowed the user' };
  }

  async isFollowing(user: any, targetUserId: string) {
    const follow = await this.followProfileRepository.findOne({
      where: {
        followerId: user.id,
        followingId: targetUserId,
      },
    });

    return { isFollowing: !!follow };
  }

  async getCurrentUserData(user: any) {
    if (!user) {
      throw new HttpException(
        'No authenticated user found',
        HttpStatus.UNAUTHORIZED,
      );
    }

    const userData = await this.userRepository.findOne({
      where: { id: user.id },
    });

    if (!userData) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    delete userData.password;

    return userData;
  }

  async getUserById(id: string): Promise<any> {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new HttpException(
        `User with id ${id} not found`,
        HttpStatus.NOT_FOUND,
      );
    }

    const userProfile = await this.userProfileRepository.findOne({
      where: { user: { id: user.id } },
      relations: ['reviews'],
    });

    delete user.password;
    delete userProfile?.updated_at;
    delete userProfile?.theme;
    delete userProfile?.language;

    Object.assign(user, userProfile);

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

    const image = updateUserDto.avatar_url;

    if (image && typeof image === 'string' && image.startsWith('data:')) {
      if (currentUserProfile.avatar_url) {
        const oldPublicId = this.cloudinaryService.extractPublicId(
          currentUserProfile.avatar_url,
        );
        if (oldPublicId) {
          await this.cloudinaryService.deleteImage(oldPublicId);
        }
      }

      const uploadResult = await this.cloudinaryService.uploadBase64(
        CLOUDINARY_DIR.AVATARS,
        image,
      );
      updateUserDto.avatar_url = uploadResult.secure_url;
    }

    Object.assign(currentUserProfile, updateUserDto);

    return await this.userProfileRepository.save(currentUserProfile);
  }

  async createUser(createUserDto: CreateUserDto): Promise<any> {
    const { email, username } = createUserDto;

    // throw new HttpException('Invalid or expired link', HttpStatus.BAD_REQUEST);

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

    // перенести після відправки емейлу
    const savedUser = await this.userRepository.save(newUser);
    const randomAvatar = this.avatarGeneratorService.generateAvatarUrl();

    // Create user profile
    const newProfile = new UserProfileEntity();
    newProfile.user = savedUser;
    newProfile.avatar_url = randomAvatar;
    await this.userProfileRepository.save(newProfile);

    // const verifyLink = 'http://localhost:5173/verify';
    const emailResult = await this.mailService.sendRegisterEmail(
      savedUser.email,
      savedUser.username,
      // verifyLink
    );

    if (!emailResult.success) {
      throw new HttpException(
        `Failed to send welcome email`,
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }

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

  async changePassword(
    user: any,
    changePasswordDto: ChangePasswordDto,
  ): Promise<any> {
    const { newPassword, currentPassword } = changePasswordDto;
    const existingUser = await this.findById(user.id);

    if (!existingUser) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const compareCurrentPassword = await compare(
      currentPassword,
      existingUser.password,
    );
    if (!compareCurrentPassword) {
      throw new HttpException(
        'Current password is incorrect',
        HttpStatus.UNAUTHORIZED,
      );
    }

    if (newPassword === currentPassword) {
      throw new HttpException(
        'New password must be different from current password',
        HttpStatus.BAD_REQUEST,
      );
    }

    const userToUpdate = new UserEntity();
    Object.assign(userToUpdate, {
      ...existingUser,
      password: newPassword,
      id: user.id,
    });
    await this.userRepository.save(userToUpdate);

    return this.generateUserResponse(existingUser);
  }

  async forgotPassword(email: string): Promise<{ message: string }> {
    const user = await this.userRepository.findOne({ where: { email } });

    if (user) {
      const resetToken = nanoid(64);
      const resetLink = `${process.env.FRONT_URL}/restore-password?token=${resetToken}`;

      const emailResult = await this.mailService.sendForgotPasswordEmail(
        email,
        user?.username || 'User',
        resetLink,
        // 'Password Reset Request',
      );

      if (!emailResult.success) {
        throw new HttpException(
          `Failed to send password reset email link`,
          HttpStatus.SERVICE_UNAVAILABLE,
        );
      }

      const forgotPasswordEntry = new ResetPasswordEntity();
      forgotPasswordEntry.token = resetToken;
      forgotPasswordEntry.userId = user.id;

      await this.resetPasswordRepository.save(forgotPasswordEntry);
    }

    return {
      message:
        'A password reset link has been sent to your email address if it exists in our system.',
    };
  }

  async restorePassword(body: RestorePasswordDto): Promise<any> {
    const { token, password } = body;
    const resetEntry = await this.resetPasswordRepository.findOne({
      where: { token },
      relations: ['user'],
    });

    if (!resetEntry) {
      throw new HttpException(
        'Invalid or expired link',
        HttpStatus.BAD_REQUEST,
      );
    }

    const isExpired = new Date() > new Date(resetEntry.expiresAt);
    if (isExpired) {
      throw new HttpException('Link has expired', HttpStatus.BAD_REQUEST);
    }

    const userToUpdate = new UserEntity();
    Object.assign(userToUpdate, {
      ...resetEntry.user,
      password,
    });

    const savedUser = await this.userRepository.save(userToUpdate);

    if (!savedUser) {
      throw new HttpException(
        'Failed to reset password',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    resetEntry.usedAt = new Date();
    await this.resetPasswordRepository.save(resetEntry);
    delete resetEntry.user.password;

    return resetEntry;
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
    if (user.password) {
      delete user.password;
    }
    return {
      user: {
        ...user,
        token: this.generateToken(user),
      },
    };
  }
}
