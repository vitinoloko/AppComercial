import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { join } from 'path';
import * as express from 'express';
import * as bodyParser from 'body-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // 🔥 Aumenta o limite do body JSON e URL-encoded (opcional)
  app.use(bodyParser.json({ limit: '10mb' }));
  app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));
  // 🔥 Habilita CORS
  app.enableCors();

  // 🔥 Torna a pasta "uploads" pública
  app.use('/uploads', express.static(join(__dirname, '..','..', 'uploads')));

  await app.listen(3000);
}
bootstrap()
