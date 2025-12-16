import { Module } from '@nestjs/common';
import { RecipeService } from './recipe.service';
import { RecipeController } from './recipe.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RecipeEntity } from './entity/recipe.entity';
import { CategoryEntity } from '@/category/entity/category.entity';
import { CloudinaryModule } from '@/cloudinary/cloudinary.module';
import { UserProfileEntity } from '@/user/entity/user-profile.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([RecipeEntity, CategoryEntity, UserProfileEntity]),
    CloudinaryModule,
  ],
  providers: [RecipeService],
  controllers: [RecipeController],
})
export class RecipeModule {}
