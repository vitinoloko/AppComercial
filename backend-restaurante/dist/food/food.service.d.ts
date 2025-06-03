import { Repository } from 'typeorm';
import { Food } from './food/food.entity';
export declare class FoodService {
    private foodRepository;
    constructor(foodRepository: Repository<Food>);
    create(data: Partial<Food>): Promise<Food>;
    findAll(): Promise<Food[]>;
    findOne(id: number): Promise<Food | null>;
    update(id: number, data: Partial<Food>): Promise<Food | null>;
    delete(id: number): Promise<import("typeorm").DeleteResult>;
}
