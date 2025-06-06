import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

import { FoodModule } from './food/food.module';

@Module({
  imports: [
    // 🔥 Serve arquivos estáticos (imagens)
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'uploads'),
      serveRoot: '/uploads', // acessa via http://localhost:3000/uploads
    }),

    // 🔥 Banco de dados
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: '#Bds#1N73rN41',
      database: 'restaurante',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true, // ❗ Use apenas para desenvolvimento
    }),

    // 🔥 Módulos da aplicação
    FoodModule,

  ],
})
export class AppModule {}
