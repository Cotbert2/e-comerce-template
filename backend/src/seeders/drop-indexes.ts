import { NestFactory } from '@nestjs/core';
import { SeederModule } from './seeder.module';
import { getModelToken } from '@nestjs/mongoose';
import { Model } from 'mongoose';

async function dropIndexes() {
  const app = await NestFactory.createApplicationContext(SeederModule);

  try {
    console.log('🔧 Dropping old indexes...');

    const userModel = app.get<Model<any>>(getModelToken('User'));

    // Get all indexes
    const indexes = await userModel.collection.getIndexes();
    console.log('Current indexes:', Object.keys(indexes));

    // Drop username index if exists
    if (indexes['username_1']) {
      await userModel.collection.dropIndex('username_1');
      console.log('✅ Dropped username_1 index');
    }

    console.log('✅ Index cleanup completed!');
  } catch (error) {
    console.error('❌ Error dropping indexes:', error.message);
  } finally {
    await app.close();
  }
}

dropIndexes();
