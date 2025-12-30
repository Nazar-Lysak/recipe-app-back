import { UserProfileEntity } from "../entity/user-profile.entity";
import { FollowProfileEntity } from "../entity/follow-profile.entity";

export interface ProfileWithFollowers extends UserProfileEntity {
  followers: FollowProfileEntity[];
}

export interface ProfilesResponseInterface {
  profiles: ProfileWithFollowers[];
}
