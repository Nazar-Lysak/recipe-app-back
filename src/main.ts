import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('Recipe API')
    .setDescription('The recipe API description')
    .setVersion('1.0')
    .addTag('recipes')
    .build();

  const documentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, documentFactory);

  app.enableCors({
    origin: [process.env.FRONT_URL],
    credentials: true,
  });
  
  await app.listen(Number(process.env.PORT));
}
bootstrap();
