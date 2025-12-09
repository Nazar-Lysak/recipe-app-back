import { Controller, Get } from '@nestjs/common';
import { CategoryService } from './category.service';
import { CategoryResponseInterface } from './types/categoryResponse.interface';

@Controller('category')
export class CategoryController {
  constructor(private readonly categoryService: CategoryService) {}
  @Get()
  async getAll(): Promise<CategoryResponseInterface> {
    return await this.categoryService.getAll();
  }
}
