import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
export declare class AuthController {
    private authservice;
    constructor(authservice: AuthService);
    regsiter(createUserDto: CreateUserDto, req: any): Promise<any>;
    login(username: string, password: string): Promise<{
        access_token: string;
        userIn: Record<string, any>;
    }>;
    findOne(username: string): Promise<import("../users/entities/users.entity").Users[]>;
    findAllUser(): Promise<import("../users/entities/users.entity").Users[]>;
}
