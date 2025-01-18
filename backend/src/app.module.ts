import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { join } from 'path';
import { PostsModule } from './posts/posts.module';
import { MongooseModule } from '@nestjs/mongoose';
import { CatalogModule } from './catalog/catalog.module';
import { InventoryModule } from './inventory/inventory.module';
import { UsersModule } from './users/users.module';
import { ConfigModule } from '@nestjs/config';
import { PaymentsModule } from './payments/payments.module';
import { SellsModule } from './sells/sells.module';



console.log('DB_USER',process.env.DB_USER);

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile : join(process.cwd(), 'src/schema.gql'),
    }), MongooseModule.forRoot(`mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASSWORD}@cluster0.4vufa.mongodb.net/espe?retryWrites=true&w=majority&appName=Cluster0&tlsAllowInvalidCertificates=true`), PostsModule, CatalogModule, InventoryModule, UsersModule, PaymentsModule, SellsModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
