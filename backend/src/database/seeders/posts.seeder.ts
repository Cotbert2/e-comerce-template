import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class PostsSeeder {
  constructor(@InjectConnection() private connection: Connection) {}

  async seed(): Promise<void> {
    const collection = this.connection.collection('posts');
    
    console.log('Seeding posts...');

    const posts = [
      {
        id: uuidv4(),
        title: 'Bienvenidos a nuestra tienda online',
        content: 'Estamos emocionados de lanzar nuestra nueva plataforma de e-commerce. Aquí encontrarás los mejores productos con la mejor calidad y precios.',
        author: 'Admin',
        createdAt: new Date('2024-01-15'),
        updatedAt: new Date('2024-01-15')
      },
      {
        id: uuidv4(),
        title: 'Nuevos productos electrónicos disponibles',
        content: 'Hemos añadido una nueva línea de productos electrónicos incluyendo smartphones, laptops y accesorios de las mejores marcas del mercado.',
        author: 'Equipo de Ventas',
        createdAt: new Date('2024-02-01'),
        updatedAt: new Date('2024-02-01')
      },
      {
        id: uuidv4(),
        title: 'Promoción especial en ropa de temporada',
        content: 'Aprovecha descuentos de hasta 50% en toda nuestra colección de ropa de invierno. Promoción válida hasta fin de mes.',
        author: 'Marketing',
        createdAt: new Date('2024-02-15'),
        updatedAt: new Date('2024-02-15')
      },
      {
        id: uuidv4(),
        title: 'Guía de cuidado para productos del hogar',
        content: 'Aprende cómo mantener en perfecto estado tus muebles y productos del hogar con estos consejos prácticos de nuestros expertos.',
        author: 'Experto en Hogar',
        createdAt: new Date('2024-03-01'),
        updatedAt: new Date('2024-03-01')
      },
      {
        id: uuidv4(),
        title: 'Los mejores ejercicios con equipamiento deportivo',
        content: 'Descubre rutinas efectivas que puedes hacer en casa con el equipamiento deportivo disponible en nuestra tienda.',
        author: 'Entrenador Personal',
        createdAt: new Date('2024-03-15'),
        updatedAt: new Date('2024-03-15')
      },
      {
        id: uuidv4(),
        title: 'Recomendaciones de lectura del mes',
        content: 'Nuestro equipo ha seleccionado los mejores libros de diferentes géneros para que disfrutes de una excelente lectura.',
        author: 'Bibliotecario',
        createdAt: new Date('2024-04-01'),
        updatedAt: new Date('2024-04-01')
      },
      {
        id: uuidv4(),
        title: 'Rutina de cuidado facial paso a paso',
        content: 'Sigue esta rutina diaria de cuidado facial con nuestros productos de belleza para mantener una piel radiante y saludable.',
        author: 'Especialista en Belleza',
        createdAt: new Date('2024-04-15'),
        updatedAt: new Date('2024-04-15')
      },
      {
        id: uuidv4(),
        title: 'Mantenimiento básico del automóvil',
        content: 'Conoce los cuidados básicos que debe tener tu automóvil y qué productos puedes encontrar en nuestra sección automotriz.',
        author: 'Mecánico Experto',
        createdAt: new Date('2024-05-01'),
        updatedAt: new Date('2024-05-01')
      },
      {
        id: uuidv4(),
        title: 'Los juguetes más educativos para niños',
        content: 'Descubre qué juguetes ayudan al desarrollo cognitivo y motor de los niños según su edad. Tenemos opciones para todas las edades.',
        author: 'Pedagogo',
        createdAt: new Date('2024-05-15'),
        updatedAt: new Date('2024-05-15')
      },
      {
        id: uuidv4(),
        title: 'Aprende a tocar guitarra: guía para principiantes',
        content: 'Comienza tu aventura musical con estos consejos básicos para aprender guitarra. Incluye recomendaciones de instrumentos para empezar.',
        author: 'Profesor de Música',
        createdAt: new Date('2024-06-01'),
        updatedAt: new Date('2024-06-01')
      },
      {
        id: uuidv4(),
        title: 'Crea tu jardín perfecto en casa',
        content: 'Tips y trucos para crear un hermoso jardín en casa, desde la selección de plantas hasta las herramientas necesarias.',
        author: 'Jardinero Experto',
        createdAt: new Date('2024-06-15'),
        updatedAt: new Date('2024-06-15')
      },
      {
        id: uuidv4(),
        title: 'Política de envíos y devoluciones actualizada',
        content: 'Hemos actualizado nuestras políticas de envío y devoluciones para brindarte un mejor servicio. Conoce todos los detalles aquí.',
        author: 'Servicio al Cliente',
        createdAt: new Date('2024-07-01'),
        updatedAt: new Date('2024-07-01')
      }
    ];

    await collection.insertMany(posts);
    console.log('Posts seeded successfully');
  }
}