import { Cart } from './cart.entity';
import { Food } from 'src/food/food/food.entity';
export declare class CartItem {
    id: number;
    productId: number;
    quantity: number;
    price: number;
    cart: Cart;
    product: Food;
}
