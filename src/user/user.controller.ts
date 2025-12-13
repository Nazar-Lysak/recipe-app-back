import {
  Body,
  Controller,
  Get,
  Post,
  Put,
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/createUser.dto';
import { loginUserDto } from './dto/loginUser.dto';
import type { AuthRequest } from '@/types/expressRequest.interface';
import { AuthGuard } from './guards/auth.guard';
import { UpdateUserDto } from './dto/updateUser.dto';
import { ForgotPasswordDto } from './dto/forgotPassword.dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  getAllUsers() {
    return this.userService.getAllUsers();
  }

  @Get('current')
  @UseGuards(AuthGuard)
  getCurrentUser(@Req() request: AuthRequest) {
    return this.userService.getCurrentUser(request.user);
  }

  @UsePipes(new ValidationPipe())
  @Put('current')
  @UseGuards(AuthGuard)
  updateCurrentUser(
    @Req() request: AuthRequest,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.userService.updateUser(request.user, updateUserDto);
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

  @Post('forgot-password')
  forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto): Promise<any> {
    return this.userService.forgotPassword(forgotPasswordDto.email);
  }
}
