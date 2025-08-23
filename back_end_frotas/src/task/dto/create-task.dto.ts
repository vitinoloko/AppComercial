import { IsBoolean, IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';
import { SituacaoTask } from '../enum/enum.situacao';

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  descricao: string;

  @IsEnum(SituacaoTask)
  @IsNotEmpty()
  situacao: SituacaoTask;

  @IsString()
  @IsNotEmpty()
  responsavel: string;

  @IsString()
  @IsOptional()
  observacao?: string;

  @IsNumber()
  @IsOptional()
  userId?: number;
}
