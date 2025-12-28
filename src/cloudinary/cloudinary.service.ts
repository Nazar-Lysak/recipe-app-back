import { Injectable } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';
import cloudinaryConfig from '../config/couldinary.config';
import { UploadApiResponse, UploadApiErrorResponse } from 'cloudinary';
import { AvatarGeneratorService } from '../avatar-generator/avatar-generator.service';

@Injectable()
export class CloudinaryService {
  constructor(private readonly avatarGeneratorService: AvatarGeneratorService) {
    if (process.env.NODE_ENV !== 'production') {
      process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
    }
    cloudinary.config(cloudinaryConfig());
  }

  async uploadImage(
    path: string,
    file: Express.Multer.File,
  ): Promise<UploadApiResponse> {
    return new Promise((resolve, reject) => {
      cloudinary.uploader
        .upload_stream(
          {
            folder: path,
            resource_type: 'image',
            format: 'webp',
            transformation: [{ quality: 'auto:good' }],
          },
          (error: UploadApiErrorResponse, result: UploadApiResponse) => {
            if (error) return reject(error);
            resolve(result);
          },
        )
        .end(file.buffer);
    });
  }

  async uploadBase64(
    path: string,
    base64String: string,
  ): Promise<UploadApiResponse> {
    return cloudinary.uploader.upload(base64String, {
      folder: path,
      resource_type: 'image',
      format: 'webp',
      transformation: [{ quality: 'auto:good' }],
    });
  }

  async deleteImage(publicId: string): Promise<any> {
    return cloudinary.uploader.destroy(publicId);
  }

  extractPublicId(url: string): string | null {
    if (!url || !url.includes('cloudinary.com')) {
      return null;
    }
    const defaultAvatars = this.avatarGeneratorService.listDefaultAvatars();
    if (defaultAvatars.includes(url)) {
      return null;
    }
    const parts = url.split('/');
    const uploadIndex = parts.indexOf('upload');
    if (uploadIndex === -1) return null;

    const pathAfterUpload = parts.slice(uploadIndex + 2).join('/');
    const publicId = pathAfterUpload.split('.')[0];

    return publicId;
  }
}
