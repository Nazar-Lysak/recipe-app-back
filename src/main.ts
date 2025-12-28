import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import * as bodyParser from 'body-parser';
import { ExpressAdapter } from '@nestjs/platform-express';
import express from 'express';
import { INestApplication } from '@nestjs/common';

const server = express();
let app;

// Спільна конфігурація для обох режимів
function configureApp(app: INestApplication) {
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
    origin: '*',
    credentials: false,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: [
      'Content-Type',
      'Authorization',
      'X-CSRF-Token',
      'X-Requested-With',
      'Accept',
      'Accept-Version',
      'Content-Length',
      'Content-MD5',
      'Date',
      'X-Api-Version'
    ],
  });
}

async function bootstrap() {
  if (!app) {
    // Для Vercel використовуємо Express adapter
    app = await NestFactory.create(
      AppModule,
      new ExpressAdapter(server),
    );

    configureApp(app);
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
    configureApp(app);

    const port = process.env.PORT || 3000;
    await app.listen(port);
    console.log(`Application is running on port ${port}`);
  });
}
