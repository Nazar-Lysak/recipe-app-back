import { IsUUID } from "class-validator";


export class getSingleRecipeDto {

    @IsUUID()
    readonly id: string;
}