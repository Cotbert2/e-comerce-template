import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class PaymentMethodsSeeder {
  constructor(@InjectConnection() private connection: Connection) {}

  async seed(): Promise<void> {
    const collection = this.connection.collection('paymentmethods');
    
    console.log('Seeding payment methods...');

    // Obtener algunos usuarios para asignar métodos de pago
    const usersCollection = this.connection.collection('users');
    const users = await usersCollection.find({}).limit(10).toArray();

    if (users.length === 0) {
      console.log('No users found. Please seed users first.');
      return;
    }

    const paymentMethods = [
      // Tarjetas de crédito
      {
        id: uuidv4(),
        paymentMethod: 'credit_card',
        creditCardNumber: '**** **** **** 1234',
        creditCardName: 'Juan Pérez',
        creditCardExpirationDate: '12/26',
        creditCardCVC: '***',
        user: users[0].id,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'credit_card',
        creditCardNumber: '**** **** **** 5678',
        creditCardName: 'María García',
        creditCardExpirationDate: '06/27',
        creditCardCVC: '***',
        user: users[1].id,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'credit_card',
        creditCardNumber: '**** **** **** 9012',
        creditCardName: 'Carlos López',
        creditCardExpirationDate: '03/28',
        creditCardCVC: '***',
        user: users[2].id,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      },
      // Tarjetas de regalo
      {
        id: uuidv4(),
        paymentMethod: 'gift_card',
        giftCardNumber: 'GC123456789012',
        giftCardAmount: 5000,
        giftCardStatus: 'active',
        user: users[3].id,
        creditCardNumber: null,
        creditCardName: null,
        creditCardExpirationDate: null,
        creditCardCVC: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'gift_card',
        giftCardNumber: 'GC234567890123',
        giftCardAmount: 10000,
        giftCardStatus: 'active',
        user: users[4].id,
        creditCardNumber: null,
        creditCardName: null,
        creditCardExpirationDate: null,
        creditCardCVC: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'gift_card',
        giftCardNumber: 'GC345678901234',
        giftCardAmount: 2500,
        giftCardStatus: 'partially_used',
        user: users[5].id,
        creditCardNumber: null,
        creditCardName: null,
        creditCardExpirationDate: null,
        creditCardCVC: null
      },
      // Métodos mixtos
      {
        id: uuidv4(),
        paymentMethod: 'debit_card',
        creditCardNumber: '**** **** **** 3456',
        creditCardName: 'Ana Rodríguez',
        creditCardExpirationDate: '09/25',
        creditCardCVC: '***',
        user: users[6].id,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'paypal',
        user: users[7].id,
        creditCardNumber: null,
        creditCardName: null,
        creditCardExpirationDate: null,
        creditCardCVC: null,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'transfer',
        user: users[8].id,
        creditCardNumber: null,
        creditCardName: null,
        creditCardExpirationDate: null,
        creditCardCVC: null,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      },
      {
        id: uuidv4(),
        paymentMethod: 'cash',
        user: users[9].id,
        creditCardNumber: null,
        creditCardName: null,
        creditCardExpirationDate: null,
        creditCardCVC: null,
        giftCardNumber: null,
        giftCardAmount: null,
        giftCardStatus: null
      }
    ];

    await collection.insertMany(paymentMethods);
    console.log('Payment methods seeded successfully');
  }
}