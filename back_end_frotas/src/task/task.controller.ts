import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Req,
  UseGuards,
  UnauthorizedException,
  Query,
  BadRequestException,
} from '@nestjs/common';
import { TaskService } from './task.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { JwtAuthGuard } from 'src/authentication/jwt-auth.guard';

@Controller('task')
export class TaskController {
  constructor(private readonly taskService: TaskService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() createTaskDto: CreateTaskDto, @Req() req) {
    if (!req.user) {
      throw new UnauthorizedException('Token invalido ou user não autenticado.');
    }
    return this.taskService.createTask(createTaskDto, req.user);
  }

  @Get('all')
  findAll() {
    return this.taskService.findAll();
  }

  @Get('id/:id')
  findOne(@Param('id') id: string, @Req() req) {
    const taskId = Number(id);
    if (isNaN(taskId)) {
      throw new BadRequestException('ID invalido!');
    }
    return this.taskService.findOneById(+id, req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('update/:id')
  update(@Param('id') id: string, @Body() updateTaskDto: UpdateTaskDto, @Req() req) {
    return this.taskService.update(+id, updateTaskDto, req.user);
  }
  @UseGuards(JwtAuthGuard)
  @Delete('delete/:id')
  remove(@Param('id') id: string, @Req() req) {
    return this.taskService.remove(+id, req.user);
  }

  @Get('filtro')
  filter(
    @Query('name') name?: string,
    @Query('descricao') descricao?: string,
    @Query('situacao') situacao?: string,
    @Query('responsavel') responsavel?: string
  ) {
    return this.taskService.filterTasks({ name, descricao, situacao, responsavel });
  }
}
