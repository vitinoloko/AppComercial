import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Food } from './food/food.entity';


@Injectable()
export class FoodService {
  constructor(
    @InjectRepository(Food)
    private foodRepository: Repository<Food>,
  ) {}

  create(data: Partial<Food>) {
    const food = this.foodRepository.create(data);
    return this.foodRepository.save(food);
  }

  findAll() {
    return this.foodRepository.find();
  }

  findOne(id: number) {
    return this.foodRepository.findOne({ where: { id } });
  }

  async update(id: number, data: Partial<Food>) {
    await this.foodRepository.update(id, data);
    return this.findOne(id);
  }

  delete(id: number) {
    return this.foodRepository.delete(id);
  }
}
