import { HttpCode, HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { RecipeEntity } from './entity/recipe.entity';
import { DeleteResult, Repository } from 'typeorm';
import { UserEntity } from '@/user/entity/user.entity';
import { CreateRecipeDto } from './dto/createRecipe.dto';

@Injectable()
export class RecipeService {
    constructor(
        @InjectRepository(RecipeEntity)
        private readonly recipeRepository: Repository<RecipeEntity>,
    ) {}

    createRecipe(user: UserEntity, createRecipeDto: CreateRecipeDto):Promise<RecipeEntity> {

        const recipe = new RecipeEntity();
        Object.assign(recipe, createRecipeDto);

        if(!recipe.image) {
            recipe.image = '';
        }

        if(!recipe.video) {
            recipe.video = '';
        }

        recipe.authorId = user.id; 

        return this.recipeRepository.save(recipe);
    }

    getRecipes() {
        return this.recipeRepository.find();
    }

    async getRecipeById(id: string): Promise<RecipeEntity> {
        const recipe = await this.recipeRepository.findOneBy({ id });
        if(!recipe) {
            throw new HttpException('Recipe not found', HttpStatus.NOT_FOUND);
        }
        return recipe;
    }

    async deleteRecipe(user: UserEntity, id: string): Promise<DeleteResult> {
        const recipe = await this.getRecipeById(id);

        if(!recipe) {
            throw new HttpException('Recipe not found', HttpStatus.NOT_FOUND);
        }

        if(user.id !== recipe.authorId) {
            throw new HttpException('You can only delete your own recipes', HttpStatus.FORBIDDEN);
        }

        return await this.recipeRepository.delete({ id: recipe.id });
    }
}
