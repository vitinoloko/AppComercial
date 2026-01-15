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
exports.TaskService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const task_entity_1 = require("./entities/task.entity");
const typeorm_2 = require("typeorm");
const class_transformer_1 = require("class-transformer");
let TaskService = class TaskService {
    taskRepository;
    constructor(taskRepository) {
        this.taskRepository = taskRepository;
    }
    async createTask(createTaskDto, user) {
        const situacaoEnum = createTaskDto.situacao;
        const task = this.taskRepository.create({ ...createTaskDto, user, situacao: situacaoEnum });
        const savedTask = await this.taskRepository.save(task);
        console.log('Tarefa criada com sucesso: ', (0, class_transformer_1.instanceToPlain)(savedTask));
        return (0, class_transformer_1.instanceToPlain)(savedTask);
    }
    async findAll(user) {
        const task = await this.taskRepository.find({ where: { user: { id: user.id } }, relations: ['user'] });
        if (!task || task.length === 0) {
            throw new common_1.NotFoundException('Tarefas não encontradas!');
        }
        console.log('Tarefas encontradas:', (0, class_transformer_1.instanceToPlain)(task));
        return (0, class_transformer_1.instanceToPlain)(task);
    }
    async findOneById(id, user) {
        const task = await this.taskRepository.findOne({ where: { id, user: { id: user.id } }, relations: ['user'] });
        if (!task) {
            throw new common_1.NotFoundException(`Tarefa com ID (${id}) não foi encontrada.`);
        }
        console.log('Tarefa encontrada com sucesso no banco de dados:', (0, class_transformer_1.instanceToPlain)(task));
        return (0, class_transformer_1.instanceToPlain)(task);
    }
    async filterTasks(filters, user) {
        const where = { user: { id: user.id } };
        if (filters.name)
            where.name = (0, typeorm_2.ILike)(`%${filters.name}%`);
        if (filters.descricao)
            where.descricao = (0, typeorm_2.ILike)(`%${filters.descricao}%`);
        if (filters.situacao)
            where.situacao = filters.situacao;
        if (filters.responsavel)
            where.responsavel = (0, typeorm_2.ILike)(`%${filters.responsavel}%`);
        const findTask = await this.taskRepository.find({
            where,
            relations: ['user'],
        });
        if (findTask.length > 0)
            [console.log((0, class_transformer_1.instanceToPlain)(findTask[0])), console.log('Task com o parametro:', where)];
        return (0, class_transformer_1.instanceToPlain)(findTask);
    }
    async update(id, updateTaskDto, user) {
        const task = await this.taskRepository.findOne({ where: { user: { id: user.id } }, relations: ['user'] });
        if (!task) {
            throw new common_1.NotFoundException(`Tarefa com ID (${id}) não foi encontrada.`);
        }
        if (!task.user.id) {
            throw new common_1.UnauthorizedException('Você não tem permissão para atualizar esta tarefa.');
        }
        if (updateTaskDto.situacao) {
            updateTaskDto.situacao = updateTaskDto.situacao;
        }
        this.taskRepository.merge(task, updateTaskDto);
        const updateTask = await this.taskRepository.save(task);
        console.log('Tarefa atualizada com sucesso no banco de dados:', (0, class_transformer_1.instanceToPlain)(updateTask));
        return (0, class_transformer_1.instanceToPlain)(updateTask);
    }
    async remove(id, user) {
        if (!user) {
            throw new common_1.UnauthorizedException('Usuário não autenticado.');
        }
        const task = await this.taskRepository.findOne({ where: { id }, relations: ['user'] });
        if (!task) {
            throw new common_1.NotFoundException(`Tarefa com ID (${id}) não foi encontrada para exclusão.`);
        }
        await this.taskRepository.remove(task);
        console.log('Tarefa excluída com sucesso:', (0, class_transformer_1.instanceToPlain)(task));
        return ((0, class_transformer_1.instanceToPlain)(task), { message: 'Tarefa deletada com sucesso.' });
    }
};
exports.TaskService = TaskService;
exports.TaskService = TaskService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(task_entity_1.Task)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], TaskService);
//# sourceMappingURL=task.service.js.map