import { FoodService } from './food.service';
import { Food } from './food/food.entity';
export declare class FoodController {
    private readonly foodService;
    constructor(foodService: FoodService);
    create(data: Partial<Food>): Promise<Food>;
    findAll(): Promise<Food[]>;
    findOne(id: string): Promise<Food | null>;
    update(id: string, data: Partial<Food>): Promise<Food | null>;
    remove(id: string): Promise<import("typeorm").DeleteResult>;
}
