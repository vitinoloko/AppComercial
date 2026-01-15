import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { Task } from './entities/task.entity';
import { Repository } from 'typeorm';
export declare class TaskService {
    private taskRepository;
    constructor(taskRepository: Repository<Task>);
    createTask(createTaskDto: CreateTaskDto, user: any): Promise<Task | any>;
    findAll(user: any): Promise<Task[] | any>;
    findOneById(id: number, user: any): Promise<Task | any>;
    filterTasks(filters: {
        name?: string;
        descricao?: string;
        situacao?: string;
        responsavel?: string;
    }, user: any): Promise<Task[] | any>;
    update(id: number, updateTaskDto: UpdateTaskDto, user: any): Promise<Task | any>;
    remove(id: number, user: any): Promise<{
        message: string;
    }>;
}
