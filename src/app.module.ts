import { Module } from '@nestjs/common';
import { UserModule } from '@/user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { CategoryModule } from './category/category.module';
import dbConfigProd from './config/db.config.prod';
import dbConfigDev from '@/config/db.config.dev';

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
  ],
})
export class AppModule {}
