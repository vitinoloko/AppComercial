import { CreateTaskDto } from './create-task.dto';
import { SituacaoTask } from '../enum/enum.situacao';
declare const UpdateTaskDto_base: import("@nestjs/mapped-types").MappedType<Partial<CreateTaskDto>>;
export declare class UpdateTaskDto extends UpdateTaskDto_base {
    situacao?: SituacaoTask | undefined;
}
export {};
