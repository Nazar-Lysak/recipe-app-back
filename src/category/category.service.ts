import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CategoryEntity } from './entity/category.entity';
import { Repository } from 'typeorm';
import { CategoryResponseInterface } from './types/categoryResponse.interface';

@Injectable()
export class CategoryService {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoryRepository: Repository<CategoryEntity>,
  ) {}

  async getAll(): Promise<CategoryResponseInterface> {
    const categories = await this.categoryRepository.find();
    return { categories };
  }
}
