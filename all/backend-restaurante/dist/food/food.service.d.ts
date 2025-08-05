import { Repository } from 'typeorm';
import { Food } from './food/food.entity';
export declare class FoodService {
    private foodRepository;
    constructor(foodRepository: Repository<Food>);
    create(data: Partial<Food>): Promise<Food>;
    findAll(): Promise<Food[]>;
    findOne(id: number): Promise<Food>;
    update(id: number, data: Partial<Food>): Promise<Food>;
    delete(id: number): Promise<{
        message: string;
        food: Food;
    }>;
}
