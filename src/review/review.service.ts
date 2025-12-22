import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ReviewEntity } from './entity/review.entity';
import { Repository } from 'typeorm';
import { RecipeEntity } from '@/recipe/entity/recipe.entity';
import { UserProfileEntity } from '@/user/entity/user-profile.entity';

@Injectable()
export class ReviewService {

    @InjectRepository(ReviewEntity)
    private reviewRepository: Repository<ReviewEntity>;
    @InjectRepository(RecipeEntity)
    private recipeRepository: Repository<RecipeEntity>;
    @InjectRepository(UserProfileEntity)
    private userProfileRepository: Repository<UserProfileEntity>;

    async createReview(body, user, recipeId) {

        const recipe = await this.recipeRepository.findOne({
            where: { id: recipeId },
        });

        if(!recipe) {
            throw new HttpException('Recipe not found', HttpStatus.NOT_FOUND);
        }

        const userProfile = await this.userProfileRepository.findOne({
            where: { user: { id: user.id } },
        });

        if (!userProfile) {
            throw new HttpException('User profile not found', HttpStatus.NOT_FOUND);
        }

        const existingReview = await this.reviewRepository.findOne({
            where: { 
                userId: userProfile.id,
                recipeId: recipeId 
            },
        });


        if (existingReview) {
            throw new HttpException(
                'You have already reviewed this recipe',
                HttpStatus.BAD_REQUEST,
            );
        }

        const review = new ReviewEntity();
        Object.assign(review, body);
        review.userId = userProfile.id;
        review.recipeId = recipeId;

        const savedReview = await this.reviewRepository.save(review);

        // Оновлюємо статистику рецепту
        await this.updateRecipeStats(recipeId);

        return { message: 'Review created successfully', review: savedReview };
    }

    async getRecipeReviews(recipeId: string) {
        const reviews = await this.reviewRepository.find({
            where: { recipeId },
            relations: ['user.user'],
            order: { createdAt: 'DESC' },
        });

        if (reviews.length === 0) {
            throw new HttpException('No reviews found for this recipe', HttpStatus.NOT_FOUND);
        }

        reviews.forEach(review => {
            if (review.user && review.user.user) {
                delete review.user.user.password;
            }
        });

        return reviews;
    }

    private async updateRecipeStats(recipeId: string) {
        const reviews = await this.reviewRepository.find({
            where: { recipeId },
        });

        const totalRating = reviews.reduce((sum, review) => sum + review.rating, 0);
        const averageRating = reviews.length > 0 ? totalRating / reviews.length : 0;

        await this.recipeRepository.update(recipeId, {
            averageRating: Math.round(averageRating * 10) / 10, // округлюємо до 1 знака
            reviewsCount: reviews.length,
        });
    }
}
