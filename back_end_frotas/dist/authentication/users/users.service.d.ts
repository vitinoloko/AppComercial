import { Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import { Users } from './entities/users.entity';
export declare class UsersService {
    private userRespository;
    constructor(userRespository: Repository<Users>);
    create(createUserDto: CreateUserDto, currentUser: Users): Promise<Users | any>;
    findByUsername(username: string): Promise<Users | any>;
    findUser(username: string): Promise<Pick<Users, 'id' | 'username' | 'role'> | any>;
    findAll(): Promise<Pick<Users, 'id' | 'username' | 'role'> | any>;
}
