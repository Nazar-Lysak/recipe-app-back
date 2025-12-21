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
import { UserProfileEntity } from './entity/user-profile.entity';
import { AuthMiddleware } from './middlewares/auth.middleware';
import { AvatarGeneratorModule } from '@/avatar-generator/avatar-generator.module';
import { FollowProfileEntity } from './entity/follow-profile.entity';
import { CloudinaryModule } from '@/cloudinary/cloudinary.module';
import { MailModule } from '@/mail/mail.module';
import { ResetPasswordEntity } from './entity/reset-password.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserEntity,
      UserProfileEntity,
      FollowProfileEntity,
      ResetPasswordEntity,
    ]),
    AvatarGeneratorModule,
    CloudinaryModule,
    MailModule,
  ],
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
