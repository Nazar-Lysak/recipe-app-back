import { IsEmail } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ForgotPasswordDto {
  @ApiProperty({ description: 'The email address for password recovery' })
  @IsEmail()
  readonly email: string;
}
