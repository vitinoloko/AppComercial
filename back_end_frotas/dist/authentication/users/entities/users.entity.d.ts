import { Task } from "src/task/entities/task.entity";
import { UserRole } from "../dto/create-user.dto";
export declare class Users {
    id: number;
    username: string;
    password: string;
    role: UserRole;
    createAt: Date;
    task: Task[];
}
