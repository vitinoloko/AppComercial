"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CartService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const cart_entity_1 = require("./cart.entity");
const cart_item_entity_1 = require("./cart-item.entity");
const food_service_1 = require("../food/food.service");
let CartService = class CartService {
    cartRepository;
    cartItemRepository;
    foodService;
    constructor(cartRepository, cartItemRepository, foodService) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.foodService = foodService;
    }
    async getOrCreateCart() {
        let cart = await this.cartRepository.findOneBy({});
        if (cart) {
            cart = await this.cartRepository.findOne({
                where: { id: cart.id },
                relations: ['items', 'items.product']
            });
        }
        if (!cart) {
            cart = this.cartRepository.create();
            await this.cartRepository.save(cart);
            cart = await this.cartRepository.findOne({
                where: { id: cart.id },
                relations: ['items', 'items.product']
            });
            if (!cart) {
                throw new Error("Falha catastrófica: Carrinho recém-criado não foi encontrado.");
            }
        }
        return cart;
    }
    async addItemToCart(addItemDto) {
        const { productId, quantity } = addItemDto;
        const cart = await this.getOrCreateCart();
        const food = await this.foodService.findOne(productId);
        if (!food) {
            throw new common_1.NotFoundException(`Comida com ID ${productId} não encontrada.`);
        }
        let cartItem = cart.items?.find(item => item.productId === productId);
        if (cartItem) {
            cartItem.quantity += quantity;
            if (cartItem.quantity <= 0) {
                await this.removeItemFromCart(cartItem.id);
            }
            else {
                await this.cartItemRepository.save(cartItem);
            }
        }
        else {
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
            throw new common_1.NotFoundException('Carrinho não encontrado após atualização de item.');
        }
        await this.calculateCartTotal(updatedCart);
        return await this.cartRepository.save(updatedCart);
    }
    async updateItemQuantity(cartItemId, updateItemQuantityDto) {
        const cartItem = await this.cartItemRepository.findOne({ where: { id: cartItemId }, relations: ['cart'] });
        if (!cartItem) {
            throw new common_1.NotFoundException('Item do carrinho não encontrado.');
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
            throw new common_1.NotFoundException('Carrinho não encontrado após atualização de quantidade.');
        }
        await this.calculateCartTotal(updatedCart);
        return await this.cartRepository.save(updatedCart);
    }
    async removeItemFromCart(cartItemId) {
        const cartItem = await this.cartItemRepository.findOne({ where: { id: cartItemId }, relations: ['cart'] });
        if (!cartItem) {
            throw new common_1.NotFoundException('Item do carrinho não encontrado.');
        }
        const cartId = cartItem.cart.id;
        await this.cartItemRepository.remove(cartItem);
        const updatedCart = await this.cartRepository.findOne({
            where: { id: cartId },
            relations: ['items']
        });
        if (!updatedCart) {
            return this.cartRepository.create({ id: cartId, totalAmount: 0, items: [] });
        }
        await this.calculateCartTotal(updatedCart);
        return await this.cartRepository.save(updatedCart);
    }
    async getCart() {
        const cart = await this.getOrCreateCart();
        const foundCart = await this.cartRepository.findOne({
            where: { id: cart.id },
            relations: ['items', 'items.product']
        });
        if (!foundCart) {
            return this.cartRepository.create({ id: cart.id, totalAmount: 0, items: [] });
        }
        return foundCart;
    }
    async calculateCartTotal(cart) {
        const currentCartWithItems = await this.cartRepository.findOne({
            where: { id: cart.id },
            relations: ['items']
        });
        if (currentCartWithItems) {
            cart.items = currentCartWithItems.items || [];
            cart.totalAmount = cart.items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        }
        else {
            cart.items = [];
            cart.totalAmount = 0;
            console.warn(`[calculateCartTotal] Carrinho com ID ${cart.id} não foi encontrado ao recalcular o total.`);
        }
    }
};
exports.CartService = CartService;
exports.CartService = CartService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(cart_entity_1.Cart)),
    __param(1, (0, typeorm_1.InjectRepository)(cart_item_entity_1.CartItem)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        food_service_1.FoodService])
], CartService);
//# sourceMappingURL=cart.service.js.map