import {
  HttpCode,
  HttpException,
  HttpStatus,
  Injectable,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { RecipeEntity } from './entity/recipe.entity';
import { DeleteResult, Repository } from 'typeorm';
import { UserEntity } from '@/user/entity/user.entity';
import { CreateRecipeDto } from './dto/createRecipe.dto';
import { UpdateRecipeDto } from './dto/updateRecipe.dto';
import { CategoryEntity } from '@/category/entity/category.entity';

@Injectable()
export class RecipeService {
  constructor(
    @InjectRepository(RecipeEntity)
    private readonly recipeRepository: Repository<RecipeEntity>,
    @InjectRepository(CategoryEntity)
    private readonly categoryRepository: Repository<CategoryEntity>,
  ) {}

  async createRecipe(
    user: UserEntity,
    createRecipeDto: CreateRecipeDto,
  ):Promise<RecipeEntity> {

    const categoryId = await this.categoryRepository.findOneBy({ id: createRecipeDto.category });
    if(!categoryId) {
      throw new HttpException('Category not found', HttpStatus.NOT_FOUND);
    }

    const recipe = new RecipeEntity();
    Object.assign(recipe, createRecipeDto);
    if (!recipe.image) {
      recipe.image = '';
    }
    if (!recipe.video) {
      recipe.video = '';
    }

    recipe.authorId = user.id;
    return this.recipeRepository.save(recipe);
  }

  async getRecipes(query) {
    const queryBuilder = this.recipeRepository
        .createQueryBuilder('recipe')
        .leftJoinAndSelect('recipe.author', 'author');

    if(query.category) {
        queryBuilder.andWhere('recipe.category LIKE :category', { category: `%${query.category}%` });
    }

    if(query.author) {
        queryBuilder.andWhere('author.username = :author', { author: query.author });
    }

    if(query.limit) {
        queryBuilder.limit(parseInt(query.limit));
    }

    if(query.offset) {
        queryBuilder.offset(parseInt(query.offset));
    }

    queryBuilder.orderBy('recipe.createdAt', 'DESC');

    const recipesList = await queryBuilder.getMany();
    const recipesCount = await queryBuilder.getCount();

    return {recipesList, recipesCount};
  }

  async getRecipeById(id: string): Promise<RecipeEntity> {
    const recipe = await this.recipeRepository.findOneBy({ id });
    if (!recipe) {
      throw new HttpException('Recipe not found', HttpStatus.NOT_FOUND);
    }
    return recipe;
  }

  async deleteRecipe(user: UserEntity, id: string): Promise<DeleteResult> {
    const recipe = await this.getRecipeById(id);

    if (!recipe) {
      throw new HttpException('Recipe not found', HttpStatus.NOT_FOUND);
    }

    if (user.id !== recipe.authorId) {
      throw new HttpException(
        'You can only delete your own recipes',
        HttpStatus.FORBIDDEN,
      );
    }

    return await this.recipeRepository.delete({ id: recipe.id });
  }

  async updateRecipe(
    user: UserEntity,
    id: string,
    updateRecipeDto: UpdateRecipeDto,
  ): Promise<RecipeEntity> {
    const recipe = await this.getRecipeById(id);

    if (!recipe) {
      throw new HttpException('Recipe not found', HttpStatus.NOT_FOUND);
    }

    if (user.id !== recipe.authorId) {
      throw new HttpException(
        'You can only update your own recipes',
        HttpStatus.FORBIDDEN,
      );
    }

    Object.assign(recipe, updateRecipeDto);

    return this.recipeRepository.save(recipe);
  }
}
