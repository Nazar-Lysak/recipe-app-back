import { Body, Controller, Get, Post, Req, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { RecipeService } from './recipe.service';
import { CreateRecipeDto } from './dto/createRecipe.dto';
import { UserEntity } from '@/user/entity/user.entity';
import { RecipeEntity } from './entity/recipe.entity';
import { AuthGuard } from '@/user/guards/auth.guard';

@Controller('recipe')
export class RecipeController {
    constructor(private readonly recipeService: RecipeService) {}

    @Post()
    @UsePipes(new ValidationPipe())
    @UseGuards(AuthGuard)
    createRecipe(@Req() req, @Body('recipe') createRecipeDto: CreateRecipeDto): Promise<RecipeEntity> {
        return this.recipeService.createRecipe(req.user as UserEntity, createRecipeDto as CreateRecipeDto);
    }

    @Get()
    getRecipes() {
        return this.recipeService.getRecipes();
    }
}