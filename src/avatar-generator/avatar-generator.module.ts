import { Module } from '@nestjs/common';
import { AvatarGeneratorService } from './avatar-generator.service';

@Module({
  providers: [AvatarGeneratorService],
  exports: [AvatarGeneratorService],
})
export class AvatarGeneratorModule {}
