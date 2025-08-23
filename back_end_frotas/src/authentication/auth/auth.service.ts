import { Injectable, NotFoundException, Req, UnauthorizedException } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { CreateUserDto, UserRole } from '../users/dto/create-user.dto';
import { instanceToPlain } from 'class-transformer';
import { Users } from '../users/entities/users.entity';

@Injectable()
export class AuthService {
  constructor(
    private userservice: UsersService,
    private jwtService: JwtService,
  ) {}

  async register(createUserDto: CreateUserDto, currentUser: Users) {
    return this.userservice.create(createUserDto, currentUser);
  }

  async login(username: string, password: string) {
    const user = await this.userservice.findByUsername(username);
    if (!user || !(await bcrypt.compare(password, user.password))) {
      throw new UnauthorizedException('Credenciais invalidas');
    }
    const userIn = instanceToPlain(user);
    return {
      access_token: this.jwtService.sign({ username, sub: user.id, role: user.role }),
      userIn,
    };
  }

  async findOneByusername(username: string): Promise<Users[]> {
    return this.userservice.findUser(username);
  }

  async findAllUser(): Promise<Users[]> {
    return this.userservice.findAll();
  }
}
