import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class getSingleRecipeDto {
  @ApiProperty({ description: 'The unique identifier of the recipe' })
  @IsUUID()
  readonly id: string;
}
