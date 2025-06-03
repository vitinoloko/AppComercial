import { Controller, Get, Post, Body, Param, Delete, Put, Patch, UseInterceptors, UploadedFile } from '@nestjs/common';
import { FoodService } from './food.service';
import { Food } from './food/food.entity';
@Controller('foods')
export class FoodController {
  constructor(private readonly foodService: FoodService) {}

  @Post()
  create(@Body() data: Partial<Food>) {
    return this.foodService.create(data);
  }

  @Get()
  findAll() {
    return this.foodService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.foodService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() data: Partial<Food>) {
    return this.foodService.update(+id, data);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.foodService.delete(+id);
  }
}
