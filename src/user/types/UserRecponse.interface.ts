import { UserProfileEntity } from "../entity/user-profile.entity";

export interface UserResponseInterface {
    users: {
        id: string;
        email: string;
        username: string;
        profile?: UserProfileEntity;
    }[]
}