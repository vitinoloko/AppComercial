import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Put,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FoodService } from './food.service';
import { Food } from './food/food.entity';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

@Controller('foods')
export class FoodController {
  constructor(private readonly foodService: FoodService) {}

  // 🚩 CRIAR COM IMAGEM
  @Post()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          const filename = `${file.fieldname}-${uniqueSuffix}${ext}`;
          callback(null, filename);
        },
      }),
    }),
  )
  async create(
    @UploadedFile() file: Express.Multer.File,
    @Body() data: Partial<Food>,
  ) {
    if (file) {
      data.image = `http://localhost:3000/uploads/${file.filename}`;
    }
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

  @Put(':id')
  update(@Param('id') id: string, @Body() data: Partial<Food>) {
    return this.foodService.update(+id, data);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.foodService.delete(+id);
  }
}
