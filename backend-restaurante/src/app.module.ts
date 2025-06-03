import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FoodModule } from './food/food.module';


@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: '#Bds#1N73rN41',
      database: 'restaurante',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      // synchronize: true, // ❗ Somente em desenvolvimento
      synchronize: true
    }),
    FoodModule,
  ],
})
export class AppModule {}
