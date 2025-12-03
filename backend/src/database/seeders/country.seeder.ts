import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class CountrySeeder {
  constructor(@InjectConnection() private connection: Connection) {}

  async seed(): Promise<void> {
    const collection = this.connection.collection('countries');
    
    console.log('Seeding countries...');

    const countries = [
      {
        id: uuidv4(),
        name: 'Estados Unidos',
        states: [
          {
            id: uuidv4(),
            name: 'California',
            cities: [
              { id: uuidv4(), name: 'Los Angeles' },
              { id: uuidv4(), name: 'San Francisco' },
              { id: uuidv4(), name: 'San Diego' },
            ]
          },
          {
            id: uuidv4(),
            name: 'Texas',
            cities: [
              { id: uuidv4(), name: 'Houston' },
              { id: uuidv4(), name: 'Austin' },
              { id: uuidv4(), name: 'Dallas' },
            ]
          }
        ]
      },
      {
        id: uuidv4(),
        name: 'México',
        states: [
          {
            id: uuidv4(),
            name: 'Jalisco',
            cities: [
              { id: uuidv4(), name: 'Guadalajara' },
              { id: uuidv4(), name: 'Zapopan' },
              { id: uuidv4(), name: 'Tlaquepaque' },
            ]
          },
          {
            id: uuidv4(),
            name: 'Ciudad de México',
            cities: [
              { id: uuidv4(), name: 'Benito Juárez' },
              { id: uuidv4(), name: 'Coyoacán' },
              { id: uuidv4(), name: 'Miguel Hidalgo' },
            ]
          }
        ]
      },
      {
        id: uuidv4(),
        name: 'Colombia',
        states: [
          {
            id: uuidv4(),
            name: 'Antioquia',
            cities: [
              { id: uuidv4(), name: 'Medellín' },
              { id: uuidv4(), name: 'Bello' },
              { id: uuidv4(), name: 'Itagüí' },
            ]
          },
          {
            id: uuidv4(),
            name: 'Cundinamarca',
            cities: [
              { id: uuidv4(), name: 'Bogotá' },
              { id: uuidv4(), name: 'Soacha' },
              { id: uuidv4(), name: 'Chía' },
            ]
          }
        ]
      },
      {
        id: uuidv4(),
        name: 'Argentina',
        states: [
          {
            id: uuidv4(),
            name: 'Buenos Aires',
            cities: [
              { id: uuidv4(), name: 'Buenos Aires' },
              { id: uuidv4(), name: 'La Plata' },
              { id: uuidv4(), name: 'Mar del Plata' },
            ]
          }
        ]
      },
      {
        id: uuidv4(),
        name: 'España',
        states: [
          {
            id: uuidv4(),
            name: 'Madrid',
            cities: [
              { id: uuidv4(), name: 'Madrid' },
              { id: uuidv4(), name: 'Alcalá de Henares' },
              { id: uuidv4(), name: 'Móstoles' },
            ]
          },
          {
            id: uuidv4(),
            name: 'Cataluña',
            cities: [
              { id: uuidv4(), name: 'Barcelona' },
              { id: uuidv4(), name: 'Hospitalet de Llobregat' },
              { id: uuidv4(), name: 'Terrassa' },
            ]
          }
        ]
      }
    ];

    await collection.insertMany(countries);
    console.log('Countries seeded successfully');
  }
}