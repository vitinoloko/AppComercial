import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CartService } from './cart.service';
import { Cart } from './cart.entity';
import { CartItem } from './cart-item.entity';
import { FoodModule } from '../food/food.module'; // Importa o módulo de Food para usar o FoodService
import { CartController } from './cart.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([Cart, CartItem]),
    FoodModule, // Importa FoodModule para que CartService possa usar FoodService
  ],
  providers: [CartService],
  controllers: [CartController],
  exports: [CartService] // Exporta se outros módulos precisarem interagir com CartService
})
export class CartModule {}