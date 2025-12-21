import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsString } from "class-validator";


export class RestorePasswordDto {
    @ApiProperty({ description: 'The password reset token' })
    @IsNotEmpty()
    @IsString()
    readonly token: string;

    @ApiProperty({ description: 'The new password for the user account' })
    @IsNotEmpty()
    @IsString()
    readonly password: string;
}