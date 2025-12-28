import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import * as bodyParser from 'body-parser';
import { ExpressAdapter } from '@nestjs/platform-express';
import express from 'express';

const server = express();
let app;

async function bootstrap() {
  if (!app) {
    // Для Vercel використовуємо Express adapter
    app = await NestFactory.create(
      AppModule,
      new ExpressAdapter(server),
    );

    app.use(bodyParser.json({ limit: '5mb' }));
    app.use(bodyParser.urlencoded({ limit: '5mb', extended: true }));

    const config = new DocumentBuilder()
      .setTitle('Recipe API')
      .setDescription('The recipe API description')
      .setVersion('1.0')
      .addTag('recipes')
      .build();

    const documentFactory = () => SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('api', app, documentFactory);

    app.enableCors({
      origin: true,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    });

    await app.init();
  }
  return server;
}

// Експорт для Vercel serverless
export default async (req, res) => {
  await bootstrap();
  return server(req, res);
};

// Для локального запуску
if (require.main === module) {
  const localApp = NestFactory.create(AppModule);
  localApp.then(async (app) => {
    app.use(bodyParser.json({ limit: '5mb' }));
    app.use(bodyParser.urlencoded({ limit: '5mb', extended: true }));

    const config = new DocumentBuilder()
      .setTitle('Recipe API')
      .setDescription('The recipe API description')
      .setVersion('1.0')
      .addTag('recipes')
      .build();

    const documentFactory = () => SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('api', app, documentFactory);

    app.enableCors({
      origin: true,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    });

    const port = process.env.PORT || 3000;
    await app.listen(port);
    console.log(`Application is running on port ${port}`);
  });
}
