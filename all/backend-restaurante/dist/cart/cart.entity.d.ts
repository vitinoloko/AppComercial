import { CartItem } from './cart-item.entity';
export declare class Cart {
    id: number;
    totalAmount: number;
    createdAt: Date;
    updatedAt: Date;
    items: CartItem[];
}
