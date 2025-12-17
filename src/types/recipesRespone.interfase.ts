import { RecipeEntity } from '@/recipe/entity/recipe.entity';

export interface RecipesResponseInterface {
  recipesList: RecipeEntity[];
  recipesCount: number;
}
