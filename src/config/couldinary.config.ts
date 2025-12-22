import { ConfigOptions } from 'cloudinary';

export default (): ConfigOptions => ({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
  secure: true,
});

export const CLOUDINARY_DIR = {
  AVATARS: 'avatars',
  CATEGORIES: 'categories',
  RECIPES: 'recipes',
  REVIEWS: 'reviews',
};
