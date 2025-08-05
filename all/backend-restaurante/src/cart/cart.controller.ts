import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus } from '@nestjs/common';
import { CartService } from './cart.service';
import { AddItemDto } from './dto/add-item.dto';
import { UpdateItemQuantityDto } from './dto/update-item-quantity.dto';

@Controller('cart')
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Post('add')
  @HttpCode(HttpStatus.OK) // Retorna 200 OK em vez de 201 Created para operações de adição em carrinho
  addItem(@Body() addItemDto: AddItemDto) {
    return this.cartService.addItemToCart(addItemDto);
  }

  @Patch('item/:cartItemId')
  @HttpCode(HttpStatus.OK)
  updateItemQuantity(@Param('cartItemId') cartItemId: string, @Body() updateItemQuantityDto: UpdateItemQuantityDto) {
    return this.cartService.updateItemQuantity(+cartItemId, updateItemQuantityDto);
  }

  @Delete('item/:cartItemId')
  @HttpCode(HttpStatus.NO_CONTENT) // Retorna 204 No Content para remoção bem sucedida
  removeItem(@Param('cartItemId') cartItemId: string) {
    return this.cartService.removeItemFromCart(+cartItemId);
  }

  @Get()
  getCart() {
    return this.cartService.getCart();
  }
}