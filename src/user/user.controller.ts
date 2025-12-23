import {
  Body,
  Controller,
  Delete,
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
import { ChangePasswordDto } from './dto/changePassword.dto';
import { RestorePasswordDto } from './dto/restorePassword.dto';

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

  @Get('profile/current')
  @UseGuards(AuthGuard)
  getCurrentUser(@Req() request: AuthRequest) {
    return this.userService.getCurrentUser(request.user);
  }

  @Post('profile/:id/follow')
  @UseGuards(AuthGuard)
  followUser(@Req() request: AuthRequest, @Param('id') id: string) {
    return this.userService.followUser(request.user, id);
  }

  @Delete('profile/:id/follow')
  @UseGuards(AuthGuard)
  unfollowUser(@Req() request: AuthRequest, @Param('id') id: string) {
    return this.userService.unfollowUser(request.user, id);
  }

  @Get('profile/:id/is-following')
  @UseGuards(AuthGuard)
  isFollowing(@Req() request: AuthRequest, @Param('id') id: string) {
    return this.userService.isFollowing(request.user, id);
  }

  @Get('/current')
  @UseGuards(AuthGuard)
  getCurrentUserData(@Req() request: AuthRequest) {
    return this.userService.getCurrentUserData(request.user);
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

  @Put('current/password')
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  changePassword(
    @Req() req,
    @Body() changePasswordDto: ChangePasswordDto,
  ): Promise<any> {
    return this.userService.changePassword(
      req.user as AuthRequest,
      changePasswordDto,
    );
  }

  @Post('forgot-password')
  forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto): Promise<any> {
    return this.userService.forgotPassword(forgotPasswordDto.email);
  }

  @Post('restore-password')
  @UsePipes(new ValidationPipe())
  restorePassword(
    @Body() body: RestorePasswordDto,
  ): Promise<RestorePasswordDto> {
    return this.userService.restorePassword(body);
  }
}
