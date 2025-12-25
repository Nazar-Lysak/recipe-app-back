import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import { AuthGuard } from '@/user/guards/auth.guard';
import { CreateChatDto } from './dto/cteateChat.dto';
import { ChatEntity } from './entity/chat.entity';

@Controller('chats')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Get()
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  getMyChats(@Req() req): Promise<any> {
    return this.chatService.getMyChats(req.user.id);
  }

  @Get(':chatId')
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  getSingleChat(@Param('chatId') chatId: string): Promise<any> {
    return this.chatService.getSingleChat(chatId);
  }

  @Post()
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  createChat(
    @Body() createChatDto: CreateChatDto,
    @Req() req,
  ): Promise<any> {
    return this.chatService.createChat(createChatDto, req.user.id);
  }
}
