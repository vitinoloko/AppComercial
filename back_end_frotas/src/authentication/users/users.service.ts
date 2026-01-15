import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcryptjs';
import { instanceToPlain } from 'class-transformer';
import { Users } from './entities/users.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(Users)
    private userRespository: Repository<Users>,
  ) {}

  async create(createUserDto: CreateUserDto,  currentUser: Users): Promise<Users | any> {
    if(currentUser.role !== 'admin'){
      throw new BadRequestException('Somente admin pode criar usuarios.')
    }
    const existe = await this.userRespository.findOne({
      where: { username: createUserDto.username },
    });
    if (existe) {
      throw new BadRequestException('Usuario já Existe.');
    }

    const hasedPassword = await bcrypt.hash(createUserDto.password, 10);

    const users = this.userRespository.create({
      username: createUserDto.username,
      password: hasedPassword,
      role: createUserDto.role,
    });
    const savedUser = await this.userRespository.save(users);
    console.log('User criado com sucesso!: ', instanceToPlain(savedUser));
    return instanceToPlain(savedUser);
  }

  // Usado no metodo de login para pegar o nome do user na tabela User
  async findByUsername(username: string): Promise<Users | any> {
    return this.userRespository.findOne({ where: { username } });
  }
  ///////////////////////////////////////////////////////////////////////

  async findUser(username: string): Promise<Pick<Users, 'id' | 'username' | 'role'> | any> {
    return this.userRespository.find({
      where: { username: ILike(`%${username}%`) },
      select: ['id', 'username', 'role'],
    });
  }

  async findAll(): Promise<Pick<Users, 'id' | 'username' | 'role'> | any> {
    return this.userRespository.find({
      select: ['id', 'username', 'role'],
    });
  }
}
