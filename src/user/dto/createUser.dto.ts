import { IsEmail, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ description: 'The username of the user' })
  @IsNotEmpty()
  readonly username: string;

  @ApiProperty({ description: 'The email address of the user' })
  @IsEmail()
  readonly email: string;

  @ApiProperty({ description: 'The password of the user' })
  @IsNotEmpty()
  readonly password: string;
}
