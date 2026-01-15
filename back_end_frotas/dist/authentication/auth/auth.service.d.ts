import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { Users } from '../users/entities/users.entity';
export declare class AuthService {
    private userservice;
    private jwtService;
    constructor(userservice: UsersService, jwtService: JwtService);
    register(createUserDto: CreateUserDto, currentUser: Users): Promise<any>;
    login(username: string, password: string): Promise<{
        access_token: string;
        userIn: Record<string, any>;
    }>;
    findOneByusername(username: string): Promise<Users[]>;
    findAllUser(): Promise<Users[]>;
}
