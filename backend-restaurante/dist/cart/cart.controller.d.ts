import { CartService } from './cart.service';
import { AddItemDto } from './dto/add-item.dto';
import { UpdateItemQuantityDto } from './dto/update-item-quantity.dto';
export declare class CartController {
    private readonly cartService;
    constructor(cartService: CartService);
    addItem(addItemDto: AddItemDto): Promise<import("./cart.entity").Cart>;
    updateItemQuantity(cartItemId: string, updateItemQuantityDto: UpdateItemQuantityDto): Promise<import("./cart.entity").Cart>;
    removeItem(cartItemId: string): Promise<import("./cart.entity").Cart>;
    getCart(): Promise<import("./cart.entity").Cart>;
}
