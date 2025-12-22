import { RecipeEntity } from "@/recipe/entity/recipe.entity";
import { UserProfileEntity } from "@/user/entity/user-profile.entity";
import { UserEntity } from "@/user/entity/user.entity";
import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";


@Entity('reviews')
export class ReviewEntity {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    recipeId: string;

    @Column()
    userId: string;

    @Column({ type: 'int' })
    rating: number;

    @Column({ nullable: true })
    imageUrl?: string;

    @Column({ type: 'text', nullable: true })
    comment: string;

    @Column({ default: false })
    isBlocked: boolean;

    @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    createdAt: Date;

    @ManyToOne(() => UserProfileEntity, userProfile => userProfile.reviews, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'userId' })
    user: UserProfileEntity;

    @ManyToOne(() => RecipeEntity, recipe => recipe.reviews, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'recipeId' })
    recipe: RecipeEntity;
}
