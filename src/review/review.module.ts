import { Module } from '@nestjs/common';
import { ReviewController } from './review.controller';
import { ReviewService } from './review.service';
import { ReviewEntity } from './entity/review.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RecipeEntity } from '@/recipe/entity/recipe.entity';
import { UserProfileEntity } from '@/user/entity/user-profile.entity';
import { CloudinaryModule } from '@/cloudinary/cloudinary.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([ReviewEntity, RecipeEntity, UserProfileEntity]),
    CloudinaryModule,
  ],
  controllers: [ReviewController],
  providers: [ReviewService],
})
export class ReviewModule {}
