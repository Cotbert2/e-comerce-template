import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class InventorySeeder {
  constructor(@InjectConnection() private connection: Connection) {}

  async seed(): Promise<void> {
    const categoriesCollection = this.connection.collection('categories');
    const providersCollection = this.connection.collection('providers');
    const productsCollection = this.connection.collection('products');
    
    console.log('Seeding inventory...');

    // Crear categorías
    const categories = [
      {
        id: uuidv4(),
        name: 'Electrónicos',
        description: 'Dispositivos electrónicos y gadgets'
      },
      {
        id: uuidv4(),
        name: 'Ropa',
        description: 'Vestimenta y accesorios de moda'
      },
      {
        id: uuidv4(),
        name: 'Hogar',
        description: 'Artículos para el hogar y decoración'
      },
      {
        id: uuidv4(),
        name: 'Deportes',
        description: 'Equipamiento deportivo y fitness'
      },
      {
        id: uuidv4(),
        name: 'Libros',
        description: 'Literatura y material educativo'
      },
      {
        id: uuidv4(),
        name: 'Salud',
        description: 'Productos de salud y belleza'
      },
      {
        id: uuidv4(),
        name: 'Automóvil',
        description: 'Accesorios y repuestos para automóviles'
      },
      {
        id: uuidv4(),
        name: 'Juguetes',
        description: 'Juguetes y entretenimiento infantil'
      },
      {
        id: uuidv4(),
        name: 'Música',
        description: 'Instrumentos musicales y accesorios'
      },
      {
        id: uuidv4(),
        name: 'Jardinería',
        description: 'Herramientas y plantas para jardín'
      }
    ];

    // Crear proveedores
    const providers = [
      {
        id: uuidv4(),
        name: 'TechSupplier S.A.',
        email: 'ventas@techsupplier.com',
        phone: '+52 555 1111111',
        description: 'Proveedor especializado en tecnología',
        country: 'México'
      },
      {
        id: uuidv4(),
        name: 'Fashion World Inc.',
        email: 'contact@fashionworld.com',
        phone: '+1 555 2222222',
        description: 'Distribuidor internacional de moda',
        country: 'Estados Unidos'
      },
      {
        id: uuidv4(),
        name: 'Home Comfort Ltd.',
        email: 'info@homecomfort.com',
        phone: '+34 555 3333333',
        description: 'Artículos para el hogar de calidad',
        country: 'España'
      },
      {
        id: uuidv4(),
        name: 'Sports Pro Colombia',
        email: 'ventas@sportspro.co',
        phone: '+57 555 4444444',
        description: 'Equipamiento deportivo profesional',
        country: 'Colombia'
      },
      {
        id: uuidv4(),
        name: 'Book Universe S.R.L.',
        email: 'pedidos@bookuniverse.com.ar',
        phone: '+54 555 5555555',
        description: 'Editorial y distribuidora de libros',
        country: 'Argentina'
      },
      {
        id: uuidv4(),
        name: 'Wellness Solutions',
        email: 'info@wellness.mx',
        phone: '+52 555 6666666',
        description: 'Productos de salud y bienestar',
        country: 'México'
      },
      {
        id: uuidv4(),
        name: 'Auto Parts Express',
        email: 'ventas@autoparts.com',
        phone: '+1 555 7777777',
        description: 'Repuestos automotrices originales',
        country: 'Estados Unidos'
      },
      {
        id: uuidv4(),
        name: 'Toy Kingdom',
        email: 'orders@toykingdom.es',
        phone: '+34 555 8888888',
        description: 'Juguetes educativos y de entretenimiento',
        country: 'España'
      },
      {
        id: uuidv4(),
        name: 'Music Store Colombia',
        email: 'info@musicstore.co',
        phone: '+57 555 9999999',
        description: 'Instrumentos musicales de todas las marcas',
        country: 'Colombia'
      },
      {
        id: uuidv4(),
        name: 'Garden Paradise',
        email: 'contacto@gardenparadise.com.ar',
        phone: '+54 555 0000000',
        description: 'Todo para tu jardín y plantas',
        country: 'Argentina'
      }
    ];

    // Insertar categorías y proveedores primero para obtener sus _id
    const insertedCategories = await categoriesCollection.insertMany(categories);
    const insertedProviders = await providersCollection.insertMany(providers);

    // Obtener los _id generados por MongoDB
    const categoryIds = Object.values(insertedCategories.insertedIds);
    const providerIds = Object.values(insertedProviders.insertedIds);

    // Crear productos con referencias correctas a los _id
    const products = [
      {
        id: uuidv4(),
        name: 'iPhone 15 Pro',
        price: 25999,
        description: 'Smartphone Apple iPhone 15 Pro con cámara profesional',
        stock: 50,
        category: categoryIds[0], // Electrónicos
        provider: providerIds[0], // TechSupplier S.A.
        rating: 4.8,
        discount: 5,
        image: 'https://m.media-amazon.com/images/I/61v5Jay9F5L._AC_UF894,1000_QL80_.jpg'
      },
      {
        id: uuidv4(),
        name: 'Samsung Galaxy S24',
        price: 22999,
        description: 'Smartphone Samsung Galaxy S24 con AI integrada',
        stock: 45,
        category: categoryIds[0], // Electrónicos
        provider: providerIds[0], // TechSupplier S.A.
        rating: 4.7,
        discount: 10,
        image: 'https://mobilestore.ec/wp-content/uploads/2024/01/Samsung-Galaxy-S24-Ultra-Titanium-Black-Mobile-Store-Ecuador.jpg'
      },
      {
        id: uuidv4(),
        name: 'Laptop Dell Inspiron',
        price: 18999,
        description: 'Laptop Dell Inspiron 15 con procesador Intel i7',
        stock: 40,
        category: categoryIds[0], // Electrónicos
        provider: providerIds[0], // TechSupplier S.A.
        rating: 4.5,
        discount: 12,
        image: 'https://mobilestore.ec/wp-content/uploads/2021/09/Dell-Inspiron-15-3000-Mobile-Store-Ecuador3.jpg'
      },
      {
        id: uuidv4(),
        name: 'Camiseta Polo Clásica',
        price: 599,
        description: 'Camiseta polo de algodón 100% en varios colores',
        stock: 100,
        category: categoryIds[1], // Ropa
        provider: providerIds[1], // Fashion World Inc.
        rating: 4.3,
        discount: 0,
        image: 'https://m.media-amazon.com/images/I/81NahZXF9QL._AC_SL1396_.jpg'
      },
      {
        id: uuidv4(),
        name: 'Sofá 3 Plazas Moderno',
        price: 15999,
        description: 'Sofá moderno de 3 plazas en tela premium',
        stock: 15,
        category: categoryIds[2], // Hogar
        provider: providerIds[2], // Home Comfort Ltd.
        rating: 4.6,
        discount: 15,
        image: 'https://i5.walmartimages.com/seo/3-Seater-Sofa-Couch-Modern-Linen-Tufed-Upholstered-2-Pillows-Armrest-Design-Wooden-Tapered-Legs-Accent-Arm-Sofas-Living-Room-Bedroom-Office-Grey_04ec8f14-062d-44d0-9aed-9dac7be853b9.5e2b287cd25bd91421fd9bb39412dbc8.jpeg'
      },
      {
        id: uuidv4(),
        name: 'Bicicleta Mountain Bike',
        price: 8999,
        description: 'Bicicleta de montaña con suspensión completa',
        stock: 25,
        category: categoryIds[3], // Deportes
        provider: providerIds[3], // Sports Pro Colombia
        rating: 4.5,
        discount: 20,
        image: 'https://www.bicis.ec/cdn/shop/files/bicicleta-cube-reaction-hybrid-performance-625-negro-gris-aro-29-talla-18-1-2048-2048_6062e1ed-ef0e-493a-ad0b-50eb09f37b35_600x.webp?v=1712093210'
      },
      {
        id: uuidv4(),
        name: 'El Quijote de la Mancha',
        price: 299,
        description: 'Edición especial del clásico de Cervantes',
        stock: 200,
        category: categoryIds[4], // Libros
        provider: providerIds[4], // Book Universe S.R.L.
        rating: 4.9,
        discount: 0,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8G-rtWePXp3vy3x5WiP_VvErqYUYVAGjz_w&s'
      },
      {
        id: uuidv4(),
        name: 'Crema Facial Anti-edad',
        price: 1299,
        description: 'Crema facial con colágeno y vitamina E',
        stock: 80,
        category: categoryIds[5], // Salud
        provider: providerIds[5], // Wellness Solutions
        rating: 4.4,
        discount: 25,
        image: 'https://bassa.com.ec/wp-content/uploads/2020/08/BB-crema-antiedad-1200x1200Lok.jpg'
      },
      {
        id: uuidv4(),
        name: 'Llantas Michelin R16',
        price: 3999,
        description: 'Juego de 4 llantas Michelin para automóvil',
        stock: 30,
        category: categoryIds[6], // Automóvil
        provider: providerIds[6], // Auto Parts Express
        rating: 4.7,
        discount: 10,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREfbdHn04KDKWd2SrhSSRQwtRxiii1D27OGQ&s'
      },
      {
        id: uuidv4(),
        name: 'LEGO Creator Expert',
        price: 2999,
        description: 'Set de construcción LEGO Creator Expert 2000 piezas',
        stock: 60,
        category: categoryIds[7], // Juguetes
        provider: providerIds[7], // Toy Kingdom
        rating: 4.8,
        discount: 0,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnbF-TQWbVuxUYfw3WjlmFRJq9xM1qjSfbtQ&s'
      },
      {
        id: uuidv4(),
        name: 'Guitarra Acústica Yamaha',
        price: 4999,
        description: 'Guitarra acústica Yamaha para principiantes',
        stock: 35,
        category: categoryIds[8], // Música
        provider: providerIds[8], // Music Store Colombia
        rating: 4.6,
        discount: 15,
        image: 'https://www.megaacustica.com/wp-content/uploads/2021/11/1-3.png'
      },
      {
        id: uuidv4(),
        name: 'Maceta de Cerámica',
        price: 199,
        description: 'Maceta decorativa de cerámica para plantas',
        stock: 150,
        category: categoryIds[9], // Jardinería
        provider: providerIds[9], // Garden Paradise
        rating: 4.2,
        discount: 0,
        image: 'https://kywiec.vtexassets.com/arquivos/ids/159056/403385.jpg?v=638380025676970000'
      }
    ];

    await productsCollection.insertMany(products);
    console.log('Inventory seeded successfully');
  }
}