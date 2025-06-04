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
exports.FoodService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const food_entity_1 = require("./food/food.entity");
let FoodService = class FoodService {
    foodRepository;
    constructor(foodRepository) {
        this.foodRepository = foodRepository;
    }
    async create(data) {
        const food = this.foodRepository.create(data);
        return await this.foodRepository.save(food);
    }
    async findAll() {
        return await this.foodRepository.find();
    }
    async findOne(id) {
        const food = await this.foodRepository.findOne({ where: { id } });
        if (!food)
            throw new common_1.NotFoundException('Item não encontrado');
        return food;
    }
    async update(id, data) {
        await this.foodRepository.update(id, data);
        return this.findOne(id);
    }
    async delete(id) {
        const food = await this.findOne(id);
        await this.foodRepository.delete(id);
        return { message: 'Item deletado com sucesso', food };
    }
};
exports.FoodService = FoodService;
exports.FoodService = FoodService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(food_entity_1.Food)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], FoodService);
//# sourceMappingURL=food.service.js.map