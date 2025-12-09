import { Injectable, NestMiddleware } from '@nestjs/common';
import { Response, NextFunction } from 'express';
import { UserService } from '../user.service';
import { AuthRequest } from '@/types/expressRequest.interface';
import { verify } from 'jsonwebtoken';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AuthMiddleware implements NestMiddleware {
  constructor(
    private readonly userService: UserService,
    private readonly configService: ConfigService,
  ) {}

  async use(req: AuthRequest, res: Response, next: NextFunction) {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      req.user = null;
      next();
      return;
    }

    try {
      const secret = this.configService.get<string>('JWT_SECRET');
      const decodedToken = verify(token, secret) as { id: string };
      req.user = await this.userService.findById(decodedToken.id);
    } catch (error) {
      req.user = null;
    }

    next();
  }
}
