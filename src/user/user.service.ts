import { compare } from 'bcrypt';
import { sign, verify } from 'jsonwebtoken';
import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/createUser.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from './entity/user.entity';
import { Repository } from 'typeorm';
import { env } from 'process';
import { loginUserDto } from './dto/loginUser.dto';

const saltOrRounds = 10;

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(UserEntity)
    private userRepository: Repository<UserEntity>,
  ) {}

  async getAllUsers() {
    const users = await this.userRepository.find();
    const createResult = users.map((user) => {
      const { id, password, ...result } = user;
      return result;
    });
    return { users: createResult };
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
    return {
      user: {
        ...user,
        token: this.generateToken(user),
      },
    };
  }
}
