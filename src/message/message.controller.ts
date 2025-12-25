import {
  Body,
  Controller,
  Param,
  Post,
  Put,
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { MessageService } from './message.service';
import { AuthGuard } from '@/user/guards/auth.guard';
import { CreateMessageDto } from './dto/createMessage.dto';

@Controller('messages')
export class MessageController {
  constructor(readonly messageService: MessageService) {}

  @Post(':chatId')
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  createMessage(
    @Param('chatId') chatId: string,
    @Body() createMessageDto: CreateMessageDto,
    @Req() req,
  ) {
    return this.messageService.createMessage(
      chatId,
      createMessageDto,
      req.user.id,
    );
  }

  @Put(':chatId')
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  markMessagesAsRead(
    @Req() req,
    @Param('chatId') chatId: string,
  ): Promise<void> {
    return this.messageService.markMessagesAsRead(chatId, req.user.id);
  }
}
