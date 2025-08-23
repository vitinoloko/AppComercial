import { IsIn, IsNotEmpty, IsString, MinLength } from 'class-validator';
export type UserRole = 'admin' | 'user';
export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  username: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(6)
  password: string; // hash

  @IsString()
  @IsIn(['admin', 'user'], { message: 'role must be either admin or user' })
  role: UserRole;
}
