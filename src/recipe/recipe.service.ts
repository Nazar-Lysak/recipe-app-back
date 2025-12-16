import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { RecipeEntity } from './entity/recipe.entity';
import { DeleteResult, Repository } from 'typeorm';
import { UserEntity } from '@/user/entity/user.entity';
import { CreateRecipeDto } from './dto/createRecipe.dto';
import { UpdateRecipeDto } from './dto/updateRecipe.dto';
import { CategoryEntity } from '@/category/entity/category.entity';
import { CloudinaryService } from '@/cloudinary/cloudinary.service';
import { RecipesResponseInterface } from '@/types/recipesRespone.interfase';
import { UserProfileEntity } from '@/user/entity/user-profile.entity';

@Injectable()
export class RecipeService {
  constructor(
    @InjectRepository(RecipeEntity)
    private readonly recipeRepository: Repository<RecipeEntity>,
    @InjectRepository(CategoryEntity)
    private readonly categoryRepository: Repository<CategoryEntity>,
    @InjectRepository(UserProfileEntity)
    private readonly userProfileRepository: Repository<UserProfileEntity>,
    private readonly cloudinaryService: CloudinaryService,
  ) {}

  async createRecipe(
    user: UserEntity,
    createRecipeDto: CreateRecipeDto,
  ): Promise<RecipeEntity> {
    const categoryId = await this.categoryRepository.findOneBy({
      id: createRecipeDto.category,
    });
    if (!categoryId) {
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

  async getRecipes(query): Promise<RecipesResponseInterface> {
    const queryBuilder = this.recipeRepository
      .createQueryBuilder('recipe')
      .leftJoinAndSelect('recipe.author', 'author')
      .leftJoinAndSelect('author.profile', 'profile')
      .leftJoinAndSelect('recipe.category', 'category');

    if (query.category) {
      queryBuilder.andWhere('category.id = :category', {
        category: query.category,
      });
    }

    if (query.author) {
      queryBuilder.andWhere('author.username = :author', {
        author: query.author,
      });
    }

    if(query.top) {
      queryBuilder.orderBy('recipe.favouriteCount', 'DESC');
    }

    if (query.limit) {
      queryBuilder.limit(parseInt(query.limit));
    }

    if (query.offset) {
      queryBuilder.offset(parseInt(query.offset));
    }

    if (query.oldest) {
      queryBuilder.orderBy('recipe.createdAt', 'ASC');
    }

    if (query.newest) {
      queryBuilder.orderBy('recipe.createdAt', 'DESC');
    }

    if(!query.newest && !query.oldest) {
      queryBuilder.orderBy('recipe.createdAt', 'DESC');
    }

    let recipesList = await queryBuilder.getMany();
    
    if(query.uniqueAuthors) {
      const uniqueMap = new Map();
      recipesList.forEach((recipe) => {
        if (!uniqueMap.has(recipe.authorId)) {
          uniqueMap.set(recipe.authorId, recipe);
        }
      });
      recipesList = Array.from(uniqueMap.values());
    }

    const recipesCount = recipesList.length;

    recipesList.forEach((recipe) => {
      if (recipe.author) {
        delete recipe.author.password;
      }
    });

    return { recipesList, recipesCount };
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
      const uploadResult = await this.cloudinaryService.uploadBase64(
        'recipes',
        updateRecipeDto.image,
      );
      recipe.image = uploadResult.secure_url;
    }

    return this.recipeRepository.save(recipe);
  }

  async likeRecipe(user: UserEntity, id: string) {
    const recipe = await this.getRecipeById(id);

    if (recipe.authorId === user.id) {
      throw new HttpException(
        'You cannot favorite your own recipe',
        HttpStatus.FORBIDDEN,
      );
    }

    const userProfile = await this.userProfileRepository.findOne({
      where: { user: { id: user.id } },
      relations: ['liked_recipes'],
    });


    if (!userProfile) {
      throw new HttpException('User profile not found', HttpStatus.NOT_FOUND);
    }


    if (userProfile.liked_recipes.find(r => r.id === recipe.id)) {
      throw new HttpException(
        'You have already liked this recipe',
        HttpStatus.BAD_REQUEST,
      );
    }

    userProfile.liked_recipes.push(recipe);
    recipe.favouriteCount++;

    await this.userProfileRepository.save(userProfile);
    return this.recipeRepository.save(recipe);
  }
}
