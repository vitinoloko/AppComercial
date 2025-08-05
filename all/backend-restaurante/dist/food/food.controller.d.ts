import { FoodService } from './food.service';
import { Food } from './food/food.entity';
export declare class FoodController {
    private readonly foodService;
    constructor(foodService: FoodService);
    create(data: Partial<Food>): Promise<Food>;
    findAll(): Promise<Food[]>;
    findOne(id: string): Promise<Food>;
    update(id: string, data: Partial<Food>): Promise<Food>;
    remove(id: string): Promise<{
        message: string;
        food: Food;
    }>;
}
