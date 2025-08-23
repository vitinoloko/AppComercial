import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { Users } from './entities/users.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Users])], // ✅ registra o repositório
  providers: [UsersService],
  exports: [UsersService, TypeOrmModule], // ✅ para ser usado no AuthModule
})
export class UsersModule {}
