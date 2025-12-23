import {
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

export class CreateReviewDto {
  @IsNumber()
  @Min(1)
  @Max(5)
  readonly rating: number;

  @IsString()
  @MaxLength(500)
  readonly comment: string;

  @IsOptional()
  @IsString()
  readonly image?: string;
}
