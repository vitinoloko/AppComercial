import { IsNumber, IsInt, Min } from 'class-validator';

export class AddItemDto {
  @IsNumber()
  productId: number;

  @IsInt()
  @Min(1)
  quantity: number;
}