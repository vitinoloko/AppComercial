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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const bcrypt = require("bcryptjs");
const class_transformer_1 = require("class-transformer");
const users_entity_1 = require("./entities/users.entity");
let UsersService = class UsersService {
    userRespository;
    constructor(userRespository) {
        this.userRespository = userRespository;
    }
    async create(createUserDto, currentUser) {
        if (currentUser.role !== 'admin') {
            throw new common_1.BadRequestException('Somente admin pode criar usuarios.');
        }
        const existe = await this.userRespository.findOne({
            where: { username: createUserDto.username },
        });
        if (existe) {
            throw new common_1.BadRequestException('Usuario já Existe.');
        }
        const hasedPassword = await bcrypt.hash(createUserDto.password, 10);
        const users = this.userRespository.create({
            username: createUserDto.username,
            password: hasedPassword,
            role: createUserDto.role,
        });
        const savedUser = await this.userRespository.save(users);
        console.log('User criado com sucesso!: ', (0, class_transformer_1.instanceToPlain)(savedUser));
        return (0, class_transformer_1.instanceToPlain)(savedUser);
    }
    async findByUsername(username) {
        return this.userRespository.findOne({ where: { username } });
    }
    async findUser(username) {
        return this.userRespository.find({
            where: { username: (0, typeorm_2.ILike)(`%${username}%`) },
            select: ['id', 'username', 'role'],
        });
    }
    async findAll() {
        return this.userRespository.find({
            select: ['id', 'username', 'role'],
        });
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(users_entity_1.Users)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], UsersService);
//# sourceMappingURL=users.service.js.map