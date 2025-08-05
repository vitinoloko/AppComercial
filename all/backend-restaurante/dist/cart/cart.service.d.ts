import { Repository } from 'typeorm';
import { Cart } from './cart.entity';
import { CartItem } from './cart-item.entity';
import { FoodService } from '../food/food.service';
import { AddItemDto } from './dto/add-item.dto';
import { UpdateItemQuantityDto } from './dto/update-item-quantity.dto';
export declare class CartService {
    private cartRepository;
    private cartItemRepository;
    private foodService;
    constructor(cartRepository: Repository<Cart>, cartItemRepository: Repository<CartItem>, foodService: FoodService);
    getOrCreateCart(): Promise<Cart>;
    addItemToCart(addItemDto: AddItemDto): Promise<Cart>;
    updateItemQuantity(cartItemId: number, updateItemQuantityDto: UpdateItemQuantityDto): Promise<Cart>;
    removeItemFromCart(cartItemId: number): Promise<Cart>;
    getCart(): Promise<Cart>;
    private calculateCartTotal;
}
