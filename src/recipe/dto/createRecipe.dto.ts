import { IsArray, IsNotEmpty } from "class-validator";


export class CreateRecipeDto {
    @IsNotEmpty()
    readonly name: string;

    @IsNotEmpty()
    readonly category: string;

    @IsNotEmpty()
    readonly description: string;
    readonly image?: string;
    readonly video?: string;

    @IsNotEmpty()
    readonly time: number;

    @IsArray()
    @IsNotEmpty({ each: true })
    readonly ingredients: string[];

    @IsArray()
    @IsNotEmpty({ each: true })
    readonly steps: string[];
}