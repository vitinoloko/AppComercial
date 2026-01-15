
import { Task } from "src/task/entities/task.entity";
import { Column, Entity, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { UserRole } from "../dto/create-user.dto";
import { Exclude } from "class-transformer";
@Entity()
export class Users {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({unique: true})
  username: string;

  @Column()
  @Exclude()
  password: string; // hash

  @Column({default: 'user'})
  role: UserRole;

  @UpdateDateColumn()
  @Exclude()
  createAt: Date

  @OneToMany(() => Task, task => task.user)
  @Exclude()
  task: Task[];
}