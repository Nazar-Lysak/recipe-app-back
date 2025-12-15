import { Injectable } from '@nestjs/common';

@Injectable()
export class AvatarGeneratorService {

    generateAvatarUrl(): string {

        const avatarUrls = [
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811673/panda_xgahuc.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811672/fox_pgf15d.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811671/bunny_vved8v.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811670/sloth_hsba7y.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811670/bear_udusdj.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811669/koala_gk8qbb.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811668/elephant_mtczib.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811668/cat_zg5tls.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811668/dog_urgwjo.png',
            'https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811667/penguin_vzcpbi.png'
        ];

        const randomIndex = Math.floor(Math.random() * avatarUrls.length);
        return avatarUrls[randomIndex];
        

        
    }
}
