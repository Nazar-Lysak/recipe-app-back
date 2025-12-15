import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class GetUserByIdDto {
  @ApiProperty({ description: 'The ID of the user' })
  @IsUUID()
  @IsNotEmpty()
  readonly id: string;
}
