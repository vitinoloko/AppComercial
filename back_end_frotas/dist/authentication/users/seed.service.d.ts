import { OnModuleInit } from '@nestjs/common';
import { Users } from './entities/users.entity';
import { Repository } from 'typeorm';
export declare class SeedService implements OnModuleInit {
    private userRepo;
    constructor(userRepo: Repository<Users>);
    onModuleInit(): Promise<void>;
}
