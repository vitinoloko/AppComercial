import { SituacaoTask } from '../enum/enum.situacao';
export declare class CreateTaskDto {
    name: string;
    descricao: string;
    situacao: SituacaoTask;
    responsavel: string;
    observacao?: string;
    userId?: number;
}
