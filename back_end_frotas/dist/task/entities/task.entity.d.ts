import { Users } from 'src/authentication/users/entities/users.entity';
export declare class Task {
    id: number;
    name: string;
    descricao: string;
    situacao: string;
    responsavel: string;
    isActive: boolean;
    observacao?: string;
    updateAt: Date;
    createAt: Date;
    user: Users;
}
