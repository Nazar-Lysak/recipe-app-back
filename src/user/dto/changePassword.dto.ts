import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class ChangePasswordDto {
  @ApiProperty({ description: 'The current password of the user' })
  @IsNotEmpty()
  @IsString()
  readonly currentPassword: string;

  @ApiProperty({ description: 'The new password of the user' })
  @IsNotEmpty()
  @IsString()
  readonly newPassword: string;
}
