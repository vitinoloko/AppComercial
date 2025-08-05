import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Food } from './food/food.entity';

@Injectable()
export class FoodService {
  constructor(
    @InjectRepository(Food)
    private foodRepository: Repository<Food>,
  ) {}

  async create(data: Partial<Food>) {
    const food = this.foodRepository.create(data);
    return await this.foodRepository.save(food);
  }

  async findAll() {
    return await this.foodRepository.find();
  }

  async findOne(id: number) {
    const food = await this.foodRepository.findOne({ where: { id } });
    if (!food) throw new NotFoundException('Item não encontrado');
    return food;
  }

  async update(id: number, data: Partial<Food>) {
    await this.foodRepository.update(id, data);
    return this.findOne(id);
  }

  async delete(id: number) {
    const food = await this.findOne(id);
    await this.foodRepository.delete(id);
    return { message: 'Item deletado com sucesso', food };
  }
}
