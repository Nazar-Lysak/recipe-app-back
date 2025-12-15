import {
  MiddlewareConsumer,
  Module,
  NestModule,
  RequestMethod,
} from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entity/user.entity';
import { UserProfile } from './entity/user-profile.entity';
import { AuthMiddleware } from './middlewares/auth.middleware';
import { AvatarGeneratorModule } from '@/avatar-generator/avatar-generator.module';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity, UserProfile]), AvatarGeneratorModule],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(AuthMiddleware)
      .forRoutes({ path: '*', method: RequestMethod.ALL });
  }
}
