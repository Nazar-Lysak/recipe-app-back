import {
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateRecipeDto {
  @ApiProperty({ description: 'The name of the recipe', required: false })
  @IsOptional()
  @IsString()
  @MaxLength(80)
  readonly name: string;

  @ApiProperty({ description: 'The category of the recipe', required: false })
  @IsOptional()
  @IsString()
  readonly category: string;

  @ApiProperty({
    description: 'The description of the recipe',
    required: false,
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  readonly description: string;

  @ApiProperty({ description: 'Base64 encoded image', required: false })
  @IsOptional()
  @Matches(/^data:image\/(png|jpg|jpeg|gif|webp);base64,/, {
    message: 'Invalid image format',
  })
  readonly image?: string;

  @ApiProperty({ description: 'The video URL of the recipe', required: false })
  @IsOptional()
  @IsString()
  readonly video?: string;

  @ApiProperty({
    description: 'The time required to prepare the recipe in minutes',
    required: false,
  })
  @IsOptional()
  readonly time?: number;

  @ApiProperty({
    description: 'The list of ingredients for the recipe',
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsNotEmpty()
  readonly ingredients?: string[];

  @ApiProperty({
    description: 'The list of steps to prepare the recipe',
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsNotEmpty()
  readonly steps?: string[];
}
