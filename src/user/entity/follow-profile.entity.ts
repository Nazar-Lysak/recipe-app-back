import { Entity, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";


@Entity('follow_profiles')
export class FollowProfileEntity {

    @PrimaryGeneratedColumn('uuid')
    id: string;

    @PrimaryColumn('uuid')
    followerId: string;

    @PrimaryColumn('uuid')
    followingId: string;
}