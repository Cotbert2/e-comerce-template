import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class UsersSeeder {
  constructor(@InjectConnection() private connection: Connection) {}

  async seed(): Promise<void> {
    const usersCollection = this.connection.collection('users');
    const customersCollection = this.connection.collection('customers');
    
    console.log('Seeding users...');

    // Crear usuarios registrados
    const registerUsers = [
      {
        id: uuidv4(),
        name: 'Juan Pérez',
        email: 'juan.perez@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 1234567'
      },
      {
        id: uuidv4(),
        name: 'María García',
        email: 'maria.garcia@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 2345678'
      },
      {
        id: uuidv4(),
        name: 'Carlos López',
        email: 'carlos.lopez@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 3456789'
      },
      {
        id: uuidv4(),
        name: 'Ana Rodríguez',
        email: 'ana.rodriguez@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 4567890'
      },
      {
        id: uuidv4(),
        name: 'Luis Martínez',
        email: 'luis.martinez@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 5678901'
      },
      {
        id: uuidv4(),
        name: 'Carmen Silva',
        email: 'carmen.silva@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 6789012'
      },
      {
        id: uuidv4(),
        name: 'Roberto Fernández',
        email: 'roberto.fernandez@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 7890123'
      },
      {
        id: uuidv4(),
        name: 'Patricia Gómez',
        email: 'patricia.gomez@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 8901234'
      },
      {
        id: uuidv4(),
        name: 'Diego Morales',
        email: 'diego.morales@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 9012345'
      },
      {
        id: uuidv4(),
        name: 'Lucía Herrera',
        email: 'lucia.herrera@email.com',
        password: 'hashedPassword123',
        phone: '+52 555 0123456'
      }
    ];

    // Crear usuarios simples
    const users = registerUsers.map(user => ({
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone
    }));

    // Crear clientes
    const customers = registerUsers.map((user, index) => ({
      id: uuidv4(),
      name: user.name,
      phone: user.phone,
      identification: `ID${String(index + 1).padStart(8, '0')}`,
      user: user
    }));

    await usersCollection.insertMany(registerUsers);
    await this.connection.collection('simpleusers').insertMany(users);
    await customersCollection.insertMany(customers);
    
    console.log('Users seeded successfully');
  }
}