import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';

export class CreateRecipeDto {
  @ApiProperty({description: 'The name of the recipe'})
  @IsNotEmpty()
  @IsString()
  @MaxLength(80)
  readonly name: string;

  @ApiProperty({description: 'The category of the recipe'})
  @IsNotEmpty()
  @IsString()
  readonly category: string;

  @ApiProperty({description: 'The description of the recipe'})
  @IsNotEmpty()
  @IsString()
  readonly description: string;

  @ApiProperty({description: 'The image URL of the recipe'})
  @IsOptional()
  @IsString()
  readonly image?: string;

  @ApiProperty({description: 'The video URL of the recipe'})
  @IsOptional()
  @IsString()
  readonly video?: string;

  @ApiProperty({description: 'The time required to prepare the recipe in minutes'})
  @IsNotEmpty()
  readonly time: number;

  @ApiProperty({description: 'The list of ingredients for the recipe'})
  @IsArray()
  @IsNotEmpty()
  readonly ingredients: string[];

  @ApiProperty({description: 'The list of steps to prepare the recipe'})
  @IsArray()
  @IsNotEmpty()
  readonly steps: string[];
}
