import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { RecipeEntity } from './entity/recipe.entity';
import { Repository } from 'typeorm';
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

        delete user.password;
        recipe.authorId = user.id; 


        return this.recipeRepository.save(recipe);
    }

    getRecipes() {
        return this.recipeRepository.find();
    }
}
