import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { CountrySeeder } from './country.seeder';
import { UsersSeeder } from './users.seeder';
import { InventorySeeder } from './inventory.seeder';
import { PaymentMethodsSeeder } from './payments.seeder';
import { PostsSeeder } from './posts.seeder';
import { SellsSeeder } from './sells.seeder';

@Injectable()
export class DatabaseSeeder {
  constructor(
    @InjectConnection() private connection: Connection,
    private readonly countrySeeder: CountrySeeder,
    private readonly usersSeeder: UsersSeeder,
    private readonly inventorySeeder: InventorySeeder,
    private readonly paymentMethodsSeeder: PaymentMethodsSeeder,
    private readonly postsSeeder: PostsSeeder,
    private readonly sellsSeeder: SellsSeeder,
  ) {}

  async seed(): Promise<void> {
    console.log('Starting database seeding...');

    try {
      await this.resetDatabase();

      await this.countrySeeder.seed();
      await this.usersSeeder.seed();
      await this.inventorySeeder.seed();
      await this.paymentMethodsSeeder.seed();
      await this.postsSeeder.seed();
      await this.sellsSeeder.seed();

      console.log('Database seeding completed successfully!');
    } catch (error) {
      console.error('Error during database seeding:', error);
      throw error;
    }
  }

  private async resetDatabase(): Promise<void> {
    console.log('Resetting database...');
    
    const collections = [
      'countries',
      'users',
      'simpleusers', 
      'customers',
      'categories',
      'providers',
      'products',
      'paymentmethods',
      'posts',
      'sells'
    ];

    for (const collectionName of collections) {
      try {
        const collection = this.connection.collection(collectionName);
        await collection.deleteMany({});
        console.log(`✓ Cleared collection: ${collectionName}`);
      } catch (error) {
        // Si la colección no existe, continuamos
        console.log(`- Collection ${collectionName} doesn't exist or is already empty`);
      }
    }

    console.log('Database reset completed!');
  }
}