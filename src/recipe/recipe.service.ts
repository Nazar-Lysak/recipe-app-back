import {
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
import { CloudinaryService } from '@/cloudinary/cloudinary.service';

@Injectable()
export class RecipeService {
  constructor(
    @InjectRepository(RecipeEntity)
    private readonly recipeRepository: Repository<RecipeEntity>,
    @InjectRepository(CategoryEntity)
    private readonly categoryRepository: Repository<CategoryEntity>,
    private readonly cloudinaryService: CloudinaryService,
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
        .leftJoinAndSelect('recipe.author', 'author')
        .leftJoinAndSelect('author.profile', 'profile')
        .leftJoinAndSelect('recipe.category', 'category');

    if(query.category) {
        queryBuilder.andWhere('category.id = :category', { category: query.category });
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

    if(query.oldest === 'true') {
        queryBuilder.orderBy('recipe.createdAt', 'ASC');
    } 
    
    if(query.newest) {
        queryBuilder.orderBy('recipe.createdAt', 'DESC');
    }

    const recipesList = await queryBuilder.getMany();
    const recipesCount = await queryBuilder.getCount();

    recipesList.forEach(recipe => {
      if (recipe.author) {
        delete recipe.author.password;
      }
    });

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

    if (updateRecipeDto.image && typeof updateRecipeDto.image === 'string') {
      const uploadResult = await this.cloudinaryService.uploadBase64('recipes', updateRecipeDto.image);
      recipe.image = uploadResult.secure_url;
    }

    return this.recipeRepository.save(recipe);
  }
}
