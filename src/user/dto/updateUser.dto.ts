import {
  IsOptional,
  IsString,
  IsBoolean,
  IsUrl,
  IsEnum,
} from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  readonly first_name?: string;

  @IsOptional()
  @IsString()
  readonly last_name?: string;

  @IsOptional()
  @IsString()
  readonly bio?: string;

  @IsOptional()
  @IsUrl()
  readonly avatar_url?: string;

  @IsOptional()
  @IsUrl()
  readonly banner_url?: string;

  @IsOptional()
  @IsString()
  readonly location?: string;

  @IsOptional()
  @IsUrl()
  readonly website?: string;

  @IsOptional()
  @IsUrl()
  readonly instagram?: string;

  @IsOptional()
  @IsUrl()
  readonly tiktok?: string;

  @IsOptional()
  @IsUrl()
  readonly facebook?: string;

  @IsOptional()
  @IsUrl()
  readonly youtube?: string;

  @IsOptional()
  @IsBoolean()
  readonly is_private?: boolean;

  @IsOptional()
  @IsString()
  readonly language?: string;

  @IsOptional()
  @IsEnum(['light', 'dark'], {
    message: 'theme must be either "light" or "dark"',
  })
  theme?: 'light' | 'dark';
}
