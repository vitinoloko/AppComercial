import { Module } from '@nestjs/common';

import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app/app.controller';
import { AppService } from './app/app.service';
import { AuthModule } from './authentication/auth/auth.module';
import { UsersModule } from './authentication/users/users.module';
import { TaskModule } from './task/task.module';
import { SeedService } from './authentication/users/seed.service';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: '#Bds#1N73rN41',
      database: 'frotas_car',
      autoLoadEntities: true,
      synchronize: true,
    }),
    TaskModule,
    AuthModule,
    UsersModule,
  ],
  controllers: [AppController],
  providers: [AppService,SeedService],
})
export class AppModule {}
