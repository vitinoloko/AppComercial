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

  // CORREÇÃO ESSENCIAL: Garante que findOne sempre tenha uma condição
  // Ou encontra o primeiro carrinho (provisório para desenvolvimento)
  // Ou cria um novo se não houver nenhum.
  async getOrCreateCart(): Promise<Cart> {
    // Tenta encontrar o primeiro carrinho existente.
    // O TypeORM 0.3+ exige uma condição para findOne. findOneBy({}) é uma forma de buscar "o primeiro".
    let cart = await this.cartRepository.findOneBy({}); // <--- ALTERAÇÃO CRUCIAL AQUI!

    if (cart) {
      // Se um carrinho foi encontrado, recarregue-o com suas relações
      // para garantir que 'items' e 'items.product' estejam populados.
      cart = await this.cartRepository.findOne({
        where: { id: cart.id },
        relations: ['items', 'items.product']
      });
      // Se por algum motivo ele ainda for null aqui, algo está errado,
      // mas a lógica abaixo tratará isso.
    }

    if (!cart) {
      // Se nenhum carrinho foi encontrado ou se o recarregamento falhou, cria um novo.
      cart = this.cartRepository.create();
      await this.cartRepository.save(cart);

      // Recarrega o carrinho recém-criado para garantir as relações (mesmo que vazias por enquanto)
      cart = await this.cartRepository.findOne({
        where: { id: cart.id },
        relations: ['items', 'items.product']
      });
      // Se ainda for null aqui, lançar um erro ou tratar como um problema grave.
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

    const updatedCart = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items']
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

    const updatedCart = await this.cartRepository.findOne({
      where: { id: cartItem.cart.id },
      relations: ['items']
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

    const updatedCart = await this.cartRepository.findOne({
      where: { id: cartId },
      relations: ['items']
    });

    if (!updatedCart) {
      // Se o carrinho foi o último item e o carrinho não deve mais existir (cenário raro)
      // Você pode retornar um novo carrinho vazio ou lançar um erro específico.
      return this.cartRepository.create({ id: cartId, totalAmount: 0, items: [] });
    }

    await this.calculateCartTotal(updatedCart);
    return await this.cartRepository.save(updatedCart);
  }

  async getCart(): Promise<Cart> {
    const cart = await this.getOrCreateCart();
    // Garante que os itens e os detalhes do produto dentro dos itens sejam carregados
    const foundCart = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items', 'items.product']
    });

    if (!foundCart) {
      // Em um cenário onde o carrinho é criado, mas não encontrado imediatamente,
      // podemos retornar um carrinho vazio ou lançar um erro mais específico.
      // Aqui, vamos retornar um carrinho vazio para evitar um crash no frontend.
      return this.cartRepository.create({ id: cart.id, totalAmount: 0, items: [] });
    }

    return foundCart;
  }

  // CORREÇÃO ESSENCIAL: Garante que 'cart.items' sempre seja um array válido.
  private async calculateCartTotal(cart: Cart): Promise<void> {
    const currentCartWithItems = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items'] // Garante que os itens sejam carregados
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