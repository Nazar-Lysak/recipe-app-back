import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { RecipeService } from './recipe.service';
import { CreateRecipeDto } from './dto/createRecipe.dto';
import { UserEntity } from '@/user/entity/user.entity';
import { RecipeEntity } from './entity/recipe.entity';
import { AuthGuard } from '@/user/guards/auth.guard';
import { getSingleRecipeDto } from './dto/getSingleRecipe.dto';
import { DeleteResult } from 'typeorm';
import { UpdateRecipeDto } from './dto/updateRecipe.dto';
import { ApiTags, ApiBody } from '@nestjs/swagger';
import { RecipesResponseInterface } from '@/types/recipesRespone.interfase';

@ApiTags('Recipes')
@Controller('recipe')
export class RecipeController {
  constructor(private readonly recipeService: RecipeService) {}

  @Post()
  @ApiBody({ type: CreateRecipeDto })
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  async createRecipe(
    @Req() req,
    @Body('recipe') createRecipeDto: CreateRecipeDto,
  ): Promise<RecipeEntity> {
    return this.recipeService.createRecipe(
      req.user as UserEntity,
      createRecipeDto as CreateRecipeDto,
    );
  }

  @Get()
  getRecipes(@Query() query): Promise<RecipesResponseInterface> {
    return this.recipeService.getRecipes(query);
  }

  @Get(':id')
  @UsePipes(new ValidationPipe())
  async getRecipeById(
    @Param() param: getSingleRecipeDto,
  ): Promise<RecipeEntity> {
    return this.recipeService.getRecipeById(param.id);
  }

  @Delete(':id')
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  async deleteRecipe(
    @Req() req,
    @Param() param: getSingleRecipeDto,
  ): Promise<DeleteResult> {
    return this.recipeService.deleteRecipe(req.user as UserEntity, param.id);
  }

  @Put(':id')
  @ApiBody({ type: UpdateRecipeDto })
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  async updateRecipe(
    @Req() req,
    @Param() param: getSingleRecipeDto,
    @Body('recipe') updateRecipeDto: UpdateRecipeDto,
  ): Promise<RecipeEntity> {
    return this.recipeService.updateRecipe(
      req.user as UserEntity,
      param.id,
      updateRecipeDto as UpdateRecipeDto,
    );
  }

  @Post(':id/like')
  @UsePipes(new ValidationPipe())
  @UseGuards(AuthGuard)
  async likeRecipe(
    @Req() req,
    @Param() param: getSingleRecipeDto,
  ): Promise<any> {
    return this.recipeService.likeRecipe(req.user as UserEntity, param.id);
  }
}
