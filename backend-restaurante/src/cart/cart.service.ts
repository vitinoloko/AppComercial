// backend-restaurante/src/cart/cart.service.ts

import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cart } from './cart.entity';
import { CartItem } from './cart-item.entity';
import { FoodService } from '../food/food.service';
import { AddItemDto } from './dto/add-item.dto';
import { UpdateItemQuantityDto } from './dto/update-item-quantity.dto';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(Cart)
    private cartRepository: Repository<Cart>,
    @InjectRepository(CartItem)
    private cartItemRepository: Repository<CartItem>,
    private foodService: FoodService,
  ) {}

  async getOrCreateCart(): Promise<Cart> {
    let cart = await this.cartRepository.findOneBy({});

    if (cart) {
      // Modificado: Adicionado order aqui
      cart = await this.cartRepository.findOne({
        where: { id: cart.id },
        relations: ['items', 'items.product'],
        order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
      });
    }

    if (!cart) {
      cart = this.cartRepository.create();
      await this.cartRepository.save(cart);

      // Modificado: Adicionado order aqui para o carrinho recém-criado
      cart = await this.cartRepository.findOne({
        where: { id: cart.id },
        relations: ['items', 'items.product'],
        order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
      });
      if (!cart) {
        throw new Error("Falha catastrófica: Carrinho recém-criado não foi encontrado.");
      }
    }
    return cart;
  }

  async addItemToCart(addItemDto: AddItemDto): Promise<Cart> {
    const { productId, quantity } = addItemDto;
    const cart = await this.getOrCreateCart();

    const food = await this.foodService.findOne(productId);
    if (!food) {
      throw new NotFoundException(`Comida com ID ${productId} não encontrada.`);
    }

    let cartItem = cart.items?.find(item => item.productId === productId);

    if (cartItem) {
      cartItem.quantity += quantity;
      if (cartItem.quantity <= 0) {
        await this.removeItemFromCart(cartItem.id);
      } else {
        await this.cartItemRepository.save(cartItem);
      }
    } else {
      cartItem = this.cartItemRepository.create({
        productId,
        quantity,
        price: food.price,
        cart: cart,
      });
      await this.cartItemRepository.save(cartItem);
    }

    // Modificado: Adicionado order aqui
    const updatedCart = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items'],
      order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
    });
    if (!updatedCart) {
      throw new NotFoundException('Carrinho não encontrado após atualização de item.');
    }
    await this.calculateCartTotal(updatedCart);
    return await this.cartRepository.save(updatedCart);
  }

  async updateItemQuantity(cartItemId: number, updateItemQuantityDto: UpdateItemQuantityDto): Promise<Cart> {
    const cartItem = await this.cartItemRepository.findOne({ where: { id: cartItemId }, relations: ['cart'] });
    if (!cartItem) {
      throw new NotFoundException('Item do carrinho não encontrado.');
    }

    const { quantity } = updateItemQuantityDto;

    if (quantity <= 0) {
      return this.removeItemFromCart(cartItemId);
    }

    cartItem.quantity = quantity;
    await this.cartItemRepository.save(cartItem);

    // Modificado: Adicionado order aqui
    const updatedCart = await this.cartRepository.findOne({
      where: { id: cartItem.cart.id },
      relations: ['items'],
      order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
    });
    if (!updatedCart) {
      throw new NotFoundException('Carrinho não encontrado após atualização de quantidade.');
    }
    await this.calculateCartTotal(updatedCart);
    return await this.cartRepository.save(updatedCart);
  }

  async removeItemFromCart(cartItemId: number): Promise<Cart> {
    const cartItem = await this.cartItemRepository.findOne({ where: { id: cartItemId }, relations: ['cart'] });
    if (!cartItem) {
      throw new NotFoundException('Item do carrinho não encontrado.');
    }

    const cartId = cartItem.cart.id;
    await this.cartItemRepository.remove(cartItem);

    // Modificado: Adicionado order aqui
    const updatedCart = await this.cartRepository.findOne({
      where: { id: cartId },
      relations: ['items'],
      order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
    });

    if (!updatedCart) {
      return this.cartRepository.create({ id: cartId, totalAmount: 0, items: [] });
    }

    await this.calculateCartTotal(updatedCart);
    return await this.cartRepository.save(updatedCart);
  }

  async getCart(): Promise<Cart> {
    const cart = await this.getOrCreateCart();
    // Modificado: Adicionado order aqui
    const foundCart = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items', 'items.product'],
      order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
    });

    if (!foundCart) {
      return this.cartRepository.create({ id: cart.id, totalAmount: 0, items: [] });
    }

    return foundCart;
  }

  private async calculateCartTotal(cart: Cart): Promise<void> {
    // Modificado: Adicionado order aqui
    const currentCartWithItems = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items'],
      order: { items: { id: 'ASC' } } // <--- ADICIONADO A ORDEM!
    });

    if (currentCartWithItems) {
      cart.items = currentCartWithItems.items || [];
      cart.totalAmount = cart.items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    } else {
      cart.items = [];
      cart.totalAmount = 0;
      console.warn(`[calculateCartTotal] Carrinho com ID ${cart.id} não foi encontrado ao recalcular o total.`);
    }
  }
}