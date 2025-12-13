import { Body, Controller, Delete, Get, Param, Post, Req, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { RecipeService } from './recipe.service';
import { CreateRecipeDto } from './dto/createRecipe.dto';
import { UserEntity } from '@/user/entity/user.entity';
import { RecipeEntity } from './entity/recipe.entity';
import { AuthGuard } from '@/user/guards/auth.guard';
import { getSingleRecipeDto } from './dto/getSingleRecipe.dto';
import { DeleteResult } from 'typeorm';

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

    @Get(':id')
    @UsePipes(new ValidationPipe())
    async getRecipeById(@Param() param: getSingleRecipeDto):Promise<RecipeEntity> {
        return this.recipeService.getRecipeById(param.id);
    }

    @Delete(':id')
    @UsePipes(new ValidationPipe())
    @UseGuards(AuthGuard)
    async deleteRecipe(@Req() req, @Param() param: getSingleRecipeDto): Promise<DeleteResult> {
        return this.recipeService.deleteRecipe(req.user as UserEntity, param.id);
    }
}