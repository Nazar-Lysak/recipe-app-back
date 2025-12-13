import {
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';

export class UpdateRecipeDto {
  @IsOptional()
  @IsString()
  @MaxLength(80)
  readonly name: string;

  @IsOptional()
  @IsString()
  readonly category: string;

  @IsOptional()
  @IsString()
  @MaxLength(255)
  readonly description: string;

  @IsOptional()
  @IsString()
  readonly image?: string;

  @IsOptional()
  @IsString()
  readonly video?: string;

  @IsOptional()
  readonly time?: number;

  @IsOptional()
  @IsArray()
  @IsNotEmpty()
  readonly ingredients?: string[];

  @IsOptional()
  @IsArray()
  @IsNotEmpty()
  readonly steps?: string[];
}
