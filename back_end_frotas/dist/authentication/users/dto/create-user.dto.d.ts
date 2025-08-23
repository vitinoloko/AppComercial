export type UserRole = 'admin' | 'user';
export declare class CreateUserDto {
    username: string;
    password: string;
    role: UserRole;
}
