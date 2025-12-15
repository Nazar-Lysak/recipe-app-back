import { Module } from '@nestjs/common';
import { UserModule } from '@/user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { CategoryModule } from './category/category.module';
import { RecipeModule } from './recipe/recipe.module';
import dbConfigProd from './config/db.config.prod';
import dbConfigDev from '@/config/db.config.dev';
import { CloudinaryModule } from './cloudinary/cloudinary.module';
import { AvatarGeneratorModule } from './avatar-generator/avatar-generator.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      expandVariables: true,
      load: [dbConfigDev, dbConfigProd],
    }),
    TypeOrmModule.forRootAsync({
      useFactory:
        process.env.NODE_ENV === 'production' ? dbConfigProd : dbConfigDev,
    }),
    UserModule,
    CategoryModule,
    RecipeModule,
    CloudinaryModule,
    AvatarGeneratorModule,
  ],
})
export class AppModule {}
