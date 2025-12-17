import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Put,
  Query,
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
import { ApiTags } from '@nestjs/swagger';
import { GetUserByIdDto } from './dto/getUserById.dto';

@ApiTags('Users')
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  getAllUsers() {
    return this.userService.getAllUsers();
  }

  @Get('profile')
  getAllProfiles(@Query() query?) {
    return this.userService.getAllProfiles(query);
  }

  @Get('current')
  @UseGuards(AuthGuard)
  getCurrentUser(@Req() request: AuthRequest) {
    return this.userService.getCurrentUser(request.user);
  }

  @Get(':id')
  @UsePipes(new ValidationPipe())
  getUserById(@Param() params: GetUserByIdDto): Promise<any> {
    return this.userService.getUserById(params.id);
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
