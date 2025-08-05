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
      // Carrega o carrinho com itens e seus produtos para garantir os dados mais recentes
      cart = await this.cartRepository.findOne({
        where: { id: cart.id },
        relations: ['items', 'items.product'], // <--- IMPORTANTE: Carregar 'items.product' aqui
        order: { items: { id: 'ASC' } }
      });
    }

    if (!cart) {
      cart = this.cartRepository.create();
      await this.cartRepository.save(cart);

      cart = await this.cartRepository.findOne({
        where: { id: cart.id },
        relations: ['items', 'items.product'], // <--- IMPORTANTE: Carregar 'items.product' aqui
        order: { items: { id: 'ASC' } }
      });
      if (!cart) {
        throw new Error("Falha catastrófica: Carrinho recém-criado não foi encontrado.");
      }
    }
    // Após obter ou criar o carrinho, sempre recalcula e sincroniza os preços
    await this.calculateCartTotal(cart); // <--- CHAMA calculateCartTotal AQUI TAMBÉM
    return await this.cartRepository.save(cart); // Salva o carrinho caso o total ou preços dos itens tenham mudado
  }

  async addItemToCart(addItemDto: AddItemDto): Promise<Cart> {
    const { productId, quantity } = addItemDto;
    const cart = await this.getOrCreateCart(); // Já chama calculateCartTotal internamente

    const food = await this.foodService.findOne(productId);
    if (!food) {
      throw new NotFoundException(`Comida com ID ${productId} não encontrada.`);
    }

    let cartItem = cart.items?.find(item => item.productId === productId);

    if (cartItem) {
      cartItem.quantity += quantity;
      // Garante que o preço do item seja sempre o mais atualizado do produto
      cartItem.price = food.price; // <--- ATUALIZA O PREÇO AO ADICIONAR/ATUALIZAR QUANTIDADE
      if (cartItem.quantity <= 0) {
        await this.removeItemFromCart(cartItem.id);
      } else {
        await this.cartItemRepository.save(cartItem);
      }
    } else {
      cartItem = this.cartItemRepository.create({
        productId,
        quantity,
        price: food.price, // Já está correto aqui para novos itens
        cart: cart,
      });
      await this.cartItemRepository.save(cartItem);
    }

    // Recarrega o carrinho com os itens e seus produtos para garantir a consistência
    const updatedCart = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items', 'items.product'], // <--- IMPORTANTE: Carregar 'items.product'
      order: { items: { id: 'ASC' } }
    });
    if (!updatedCart) {
      throw new NotFoundException('Carrinho não encontrado após atualização de item.');
    }
    await this.calculateCartTotal(updatedCart); // Recalcula o total e sincroniza os preços dos itens
    return await this.cartRepository.save(updatedCart);
  }

  async updateItemQuantity(cartItemId: number, updateItemQuantityDto: UpdateItemQuantityDto): Promise<Cart> {
    const cartItem = await this.cartItemRepository.findOne({ where: { id: cartItemId }, relations: ['cart', 'product'] }); // <--- Carregar 'product' para ter o Food.price
    if (!cartItem) {
      throw new NotFoundException('Item do carrinho não encontrado.');
    }

    const { quantity } = updateItemQuantityDto;

    if (quantity <= 0) {
      return this.removeItemFromCart(cartItemId);
    }

    cartItem.quantity = quantity;
    // Sincroniza o preço do item com o preço atual do produto
    if (cartItem.product) {
        cartItem.price = cartItem.product.price; // <--- ATUALIZA O PREÇO AQUI
    }
    await this.cartItemRepository.save(cartItem);

    const updatedCart = await this.cartRepository.findOne({
      where: { id: cartItem.cart.id },
      relations: ['items', 'items.product'], // <--- IMPORTANTE: Carregar 'items.product'
      order: { items: { id: 'ASC' } }
    });
    if (!updatedCart) {
      throw new NotFoundException('Carrinho não encontrado após atualização de quantidade.');
    }
    await this.calculateCartTotal(updatedCart); // Recalcula o total e sincroniza os preços dos itens
    return await this.cartRepository.save(updatedCart);
  }

  async removeItemFromCart(cartItemId: number): Promise<Cart> {
    const cartItem = await this.cartItemRepository.findOne({ where: { id: cartItemId }, relations: ['cart'] });
    if (!cartItem) {
      throw new NotFoundException('Item do carrinho não encontrado.');
    }

    const cartId = cartItem.cart.id;
    await this.cartItemRepository.remove(cartItem);

    const updatedCart = await this.cartRepository.findOne({
      where: { id: cartId },
      relations: ['items', 'items.product'], // <--- IMPORTANTE: Carregar 'items.product'
      order: { items: { id: 'ASC' } }
    });

    if (!updatedCart) {
      // Se o carrinho ficou vazio e não foi encontrado, cria um novo carrinho vazio
      // ou lida de acordo com a sua regra de negócio.
      return this.cartRepository.create({ id: cartId, totalAmount: 0, items: [] });
    }

    await this.calculateCartTotal(updatedCart); // Recalcula o total e sincroniza os preços dos itens
    return await this.cartRepository.save(updatedCart);
  }

  async getCart(): Promise<Cart> {
    const cart = await this.getOrCreateCart(); // Este método já garante que os preços estão atualizados e o total calculado
    return cart; // Retorna o carrinho já com os preços atualizados e total calculado
  }

  private async calculateCartTotal(cart: Cart): Promise<void> {
    // É CRUCIAL que este método receba um carrinho que já tenha 'items' E 'items.product' carregados.
    // Ou, que ele recarregue o carrinho com essas relações.
    const currentCartWithItems = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items', 'items.product'], // <--- GARANTIR QUE 'items.product' É CARREGADO AQUI
      order: { items: { id: 'ASC' } }
    });

    if (currentCartWithItems) {
      cart.items = currentCartWithItems.items || [];
      let total = 0;
      for (const item of cart.items) {
        if (item.product) {
          // Sincroniza o preço do item do carrinho com o preço atual do produto
          if (item.price !== item.product.price) {
            item.price = item.product.price;
            await this.cartItemRepository.save(item); // Salva a atualização do preço do item no banco
          }
          total += item.price * item.quantity;
        } else {
          // Lida com o caso onde o produto pode não ter sido carregado (raro com eager: true)
          // ou o produto original foi deletado.
          console.warn(`[calculateCartTotal] Produto não encontrado para CartItem ID: ${item.id}.`);
          // Você pode optar por remover o item do carrinho ou usar um preço padrão/zero
        }
      }
      cart.totalAmount = total;
    } else {
      cart.items = [];
      cart.totalAmount = 0;
      console.warn(`[calculateCartTotal] Carrinho com ID ${cart.id} não foi encontrado ao recalcular o total.`);
    }
  }
}