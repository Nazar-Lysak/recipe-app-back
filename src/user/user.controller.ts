import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/createUser.dto';
import { loginUserDto } from './dto/loginUser.dto';
import type { AuthRequest } from '@/types/expressRequest.interface';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  getAllUsers() {
    return this.userService.getAllUsers();
  }

  @Get('current')
  getCurrentUser(@Req() request: AuthRequest) {
    return this.userService.getCurrentUser(request.user);
  }

  @UsePipes(new ValidationPipe())
  @Post()
  createUser(@Body() createUserDto: CreateUserDto): Promise<any> {
    return this.userService.createUser(createUserDto);
  }

  @UsePipes(new ValidationPipe())
  @Post('login')
  loginUser(@Body() loginUserDto: loginUserDto): Promise<any> {
    return this.userService.loginUser(loginUserDto);
  }
}
