import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class SellsSeeder {
  constructor(@InjectConnection() private connection: Connection) {}

  async seed(): Promise<void> {
    const collection = this.connection.collection('sells');
    
    console.log('Seeding sells...');

    // Obtener datos necesarios para las ventas
    const customersCollection = this.connection.collection('customers');
    const productsCollection = this.connection.collection('products');
    const paymentMethodsCollection = this.connection.collection('paymentmethods');

    const customers = await customersCollection.find({}).limit(10).toArray();
    const products = await productsCollection.find({}).toArray();
    const paymentMethods = await paymentMethodsCollection.find({}).toArray();

    if (customers.length === 0 || products.length === 0 || paymentMethods.length === 0) {
      console.log('Missing required data. Please seed customers, products, and payment methods first.');
      return;
    }

    const cities = [
      'Ciudad de México', 'Guadalajara', 'Monterrey', 'Puebla', 'Tijuana',
      'León', 'Juárez', 'Torreón', 'Querétaro', 'Mérida'
    ];

    const sells = Array.from({ length: 15 }, (_, index) => {
      const customer = customers[Math.floor(Math.random() * customers.length)];
      const paymentMethod = paymentMethods[Math.floor(Math.random() * paymentMethods.length)];
      const numProducts = Math.floor(Math.random() * 4) + 1; // 1 a 4 productos por venta
      
      const productsRequested = [];
      for (let i = 0; i < numProducts; i++) {
        const product = products[Math.floor(Math.random() * products.length)];
        const quantity = Math.floor(Math.random() * 3) + 1; // 1 a 3 unidades
        productsRequested.push({
          product: product,
          quantity: quantity
        });
      }

      return {
        id: uuidv4(),
        address: `Calle ${Math.floor(Math.random() * 100) + 1} #${Math.floor(Math.random() * 999) + 1}`,
        zipCode: String(Math.floor(Math.random() * 90000) + 10000),
        contactPhone: `+52 555 ${String(Math.floor(Math.random() * 9000000) + 1000000)}`,
        city: cities[Math.floor(Math.random() * cities.length)],
        paymentMethod: paymentMethod,
        customer: customer,
        products: productsRequested
      };
    });

    await collection.insertMany(sells);
    console.log('Sells seeded successfully');
  }
}