import { Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Task } from './entities/task.entity';
import { FindOptionsWhere, ILike, Repository } from 'typeorm';
import { SituacaoTask } from './enum/enum.situacao';
import { instanceToPlain } from 'class-transformer';

@Injectable()
export class TaskService {
  constructor(
    @InjectRepository(Task)
    private taskRepository: Repository<Task>,
  ) {}

  async createTask(createTaskDto: CreateTaskDto, user): Promise<Task|any> {
    const situacaoEnum = createTaskDto.situacao as SituacaoTask;

    const task = this.taskRepository.create({ ...createTaskDto, user, situacao: situacaoEnum });

    const savedTask = await this.taskRepository.save(task);

    console.log('Tarefa criada com sucesso: ', instanceToPlain(savedTask));

    return instanceToPlain(savedTask);
  }

  async findAll(user): Promise<Task[] | any> {
    const task = await this.taskRepository.find({where: { user: { id: user.id } },relations: ['user'] });
    if (!task || task.length === 0) {
      throw new NotFoundException('Tarefas não encontradas!');
    }
    console.log('Tarefas encontradas:', instanceToPlain(task));
    return instanceToPlain(task);
  }

  async findOneById(id: number, user): Promise<Task | any> {
    const task = await this.taskRepository.findOne({ where: {id, user:{id:user.id}}, relations: ['user'] });
    if (!task) {
      throw new NotFoundException(`Tarefa com ID (${id}) não foi encontrada.`);
    }
    console.log('Tarefa encontrada com sucesso no banco de dados:', instanceToPlain(task));
    return instanceToPlain(task);
  }

  async filterTasks(filters: {
    name?: string;
    descricao?: string;
    situacao?: string;
    responsavel?:string;
  },user): Promise<Task[] | any> {
    const where: FindOptionsWhere<Task> = {user:{id:user.id}}

    if (filters.name) where.name = ILike(`%${filters.name}%`);
    if (filters.descricao) where.descricao = ILike(`%${filters.descricao}%`);
    if (filters.situacao) where.situacao = filters.situacao;
    if (filters.responsavel) where.responsavel = ILike(`%${filters.responsavel}%`)

    const findTask = await this.taskRepository.find({
      where,
      relations: ['user'],
    });
    if (findTask.length > 0)
      [console.log(instanceToPlain(findTask[0])), console.log('Task com o parametro:', where)];
    return instanceToPlain(findTask);
  }

  async update(id: number, updateTaskDto: UpdateTaskDto, user): Promise<Task | any> {
    const task = await this.taskRepository.findOne({ where: { user:{id:user.id} }, relations: ['user'] });
    if (!task) {
      throw new NotFoundException(`Tarefa com ID (${id}) não foi encontrada.`);
    }
    if (!task.user.id) {
      throw new UnauthorizedException('Você não tem permissão para atualizar esta tarefa.');
    }

    if (updateTaskDto.situacao) {
      updateTaskDto.situacao = updateTaskDto.situacao as SituacaoTask;
    }

    this.taskRepository.merge(task, updateTaskDto);

    const updateTask = await this.taskRepository.save(task);

    console.log('Tarefa atualizada com sucesso no banco de dados:', instanceToPlain(updateTask));
    return instanceToPlain(updateTask);
  }

  async remove(id: number, user) {
    if (!user) {
      throw new UnauthorizedException('Usuário não autenticado.');
    }

    // if (user.role !== 'admin') {
    //   throw new UnauthorizedException('Somente admin pode excluir tarefas.');
    // }

    const task = await this.taskRepository.findOne({ where: { id }, relations: ['user'] });

    if (!task) {
      throw new NotFoundException(`Tarefa com ID (${id}) não foi encontrada para exclusão.`);
    }

    await this.taskRepository.remove(task);
    console.log('Tarefa excluída com sucesso:', instanceToPlain(task));
    return (instanceToPlain(task), { message: 'Tarefa deletada com sucesso.' });
  }

  //  async findByName(name: string): Promise <Task[]>{
  //   return this.taskRepository.find({where: {name: ILike(`%${name}%`)},
  //   relations:['user']})
  // }
  //   async findByDescricao(name: string): Promise <Task[]>{
  //   return this.taskRepository.find({where: {name: ILike(`%${name}%`)},
  //   relations:['user']})
  // }

  //   async findBySituacao(situacao: string): Promise <Task[]>{
  //   return this.taskRepository.find({where: {situacao: ILike(`%${situacao}%`)},
  //   relations:['user']})
  // }
}
