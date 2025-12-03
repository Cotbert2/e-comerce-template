import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { DatabaseSeeder } from './seeders/database.seeder';
import { CountrySeeder } from './seeders/country.seeder';
import { UsersSeeder } from './seeders/users.seeder';
import { InventorySeeder } from './seeders/inventory.seeder';
import { PaymentMethodsSeeder } from './seeders/payments.seeder';
import { PostsSeeder } from './seeders/posts.seeder';
import { SellsSeeder } from './seeders/sells.seeder';

@Module({
  providers: [
    DatabaseSeeder,
    CountrySeeder,
    UsersSeeder,
    InventorySeeder,
    PaymentMethodsSeeder,
    PostsSeeder,
    SellsSeeder,
  ],
  exports: [DatabaseSeeder],
})
export class DatabaseModule {}