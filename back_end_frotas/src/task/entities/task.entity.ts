import { Users } from 'src/authentication/users/entities/users.entity';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';
import { SituacaoTask } from '../enum/enum.situacao';
import { Type } from 'class-transformer';

@Entity()
export class Task {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  descricao: string;

  @Column({
    type: 'enum',
    enum: SituacaoTask,
    default: SituacaoTask.PENDENTE,
  })
  situacao: string;

  @Column()
  responsavel: string;

  @Column({ default: true })
  isActive: boolean;

  @Column({ nullable: true })
  observacao?: string;

  @UpdateDateColumn()
  updateAt: Date;

  @UpdateDateColumn()
  createAt: Date;

  @ManyToOne(() => Users, (user) => user.task)
  @Type(() => Users)
  user: Users;
}
