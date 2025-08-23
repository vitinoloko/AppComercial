import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Users } from './entities/users.entity';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';

 
@Injectable()
export class SeedService implements OnModuleInit {
  constructor(
    @InjectRepository(Users)
    private userRepo: Repository<Users>,
  ) {}
  async onModuleInit() {
      const count = await this.userRepo.count();
      if(count === 0){
        const hasedPassword = await bcrypt.hash('admin',10);
        const user = this.userRepo.create({
            username: 'admin',
            password: hasedPassword,
            role: 'admin',
        })
        await this.userRepo.save(user);
        console.log('👑 Usuário admin criado com sucesso!')
      }
  }
}
