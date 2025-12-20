import { Module } from '@nestjs/common';
import { CloudinaryService } from './cloudinary.service';
import { AvatarGeneratorModule } from '@/avatar-generator/avatar-generator.module';

@Module({
  imports: [AvatarGeneratorModule],
  providers: [CloudinaryService],
  exports: [CloudinaryService],
})
export class CloudinaryModule {}
