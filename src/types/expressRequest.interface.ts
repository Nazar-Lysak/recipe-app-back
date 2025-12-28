import { UserEntity } from '../user/entity/user.entity';
import { Request } from 'express';

export interface AuthRequest extends Request {
  user?: UserEntity | null;
}
