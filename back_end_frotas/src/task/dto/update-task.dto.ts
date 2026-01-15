import { PartialType } from '@nestjs/mapped-types';
import { CreateTaskDto } from './create-task.dto';
import { SituacaoTask } from '../enum/enum.situacao';

export class UpdateTaskDto extends PartialType(CreateTaskDto) {
  situacao?: SituacaoTask | undefined;
}
