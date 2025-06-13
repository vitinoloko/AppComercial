import { IsInt, Min } from 'class-validator';

export class UpdateItemQuantityDto {
  @IsInt()
  @Min(0) // Permite 0 para remoção, ou 1 para quantidades mínimas
  quantity: number;
}