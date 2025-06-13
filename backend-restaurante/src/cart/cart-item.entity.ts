import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Cart } from './cart.entity';
import { Food } from 'src/food/food/food.entity';


@Entity('cart_items')
export class CartItem {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  productId: number;

  @Column()
  quantity: number;

  @Column('float')
  price: number;

  @ManyToOne(() => Cart, cart => cart.items, { onDelete: 'CASCADE' })
  cart: Cart;

  // ESTA É A LINHA QUE PRECISA TER eager: true
  @ManyToOne(() => Food, { onDelete: 'CASCADE', eager: true }) // <-- CONFIRA SE ESTÁ ASSIM
  product: Food; // O TypeORM carregará o objeto Food completo aqui
}