import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: '*', // ⚠️ Durante desenvolvimento. Depois coloque o domínio do seu app.
  });

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
