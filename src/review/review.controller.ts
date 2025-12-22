import { Body, Controller, Get, Param, Post, Req, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { ReviewService } from './review.service';
import { AuthGuard } from '@/user/guards/auth.guard';
import { CreateReviewDto } from './dto/createReview.dto';

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewController {
    constructor(private reviewService: ReviewService) {}
    
    @Post('create/:id')
    @UseGuards(AuthGuard)
    @UsePipes(new ValidationPipe())
    createReview(
        @Req() req,
        @Body() body: CreateReviewDto,
    ) {
        return this.reviewService.createReview(body, req.user, req.params.id);
    }   

    @Get('recipe-reviews/:id')
    getRecipeReviews(
        @Param('id') id: string,
    ) {
        return this.reviewService.getRecipeReviews(id);
    }   
}
