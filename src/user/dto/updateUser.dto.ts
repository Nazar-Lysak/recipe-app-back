import {
  IsOptional,
  IsString,
  IsBoolean,
  IsUrl,
  IsEnum,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiProperty({ description: 'First name of the user', required: false })
  @IsOptional()
  @IsString()
  readonly first_name?: string;

  @ApiProperty({ description: 'Last name of the user', required: false })
  @IsOptional()
  @IsString()
  readonly last_name?: string;

  @ApiProperty({ description: 'Bio of the user', required: false })
  @IsOptional()
  @IsString()
  readonly bio?: string;

  @ApiProperty({ description: 'Avatar URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly avatar_url?: string;

  @ApiProperty({ description: 'Banner URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly banner_url?: string;

  @ApiProperty({ description: 'Location of the user', required: false })
  @IsOptional()
  @IsString()
  readonly location?: string;

  @ApiProperty({ description: 'Website URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly website?: string;

  @ApiProperty({ description: 'Instagram URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly instagram?: string;

  @ApiProperty({ description: 'TikTok URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly tiktok?: string;

  @ApiProperty({ description: 'Facebook URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly facebook?: string;

  @ApiProperty({ description: 'YouTube URL of the user', required: false })
  @IsOptional()
  @IsUrl()
  readonly youtube?: string;

  @ApiProperty({
    description: 'Privacy setting for user profile',
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  readonly is_private?: boolean;

  @ApiProperty({
    description: 'Preferred language of the user',
    required: false,
  })
  @IsOptional()
  @IsString()
  readonly language?: string;

  @ApiProperty({
    description: 'Theme preference (light or dark)',
    enum: ['light', 'dark'],
    required: false,
  })
  @IsOptional()
  @IsEnum(['light', 'dark'], {
    message: 'theme must be either "light" or "dark"',
  })
  theme?: 'light' | 'dark';
}
