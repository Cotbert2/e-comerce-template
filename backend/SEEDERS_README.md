# Database Seeders

Este proyecto incluye seeders para poblar la base de datos con datos de prueba. **IMPORTANTE**: Los seeders resetean completamente la base de datos antes de insertar los nuevos datos.

## ⚠️ Importante

**Los seeders RESETEAN completamente la base de datos antes de insertar los nuevos datos.** Esto significa que:

1. Se eliminarán TODOS los datos existentes en las siguientes colecciones:
   - countries, users, simpleusers, customers
   - categories, providers, products
   - paymentmethods, posts, sells

2. Luego se insertarán los datos de prueba desde cero

3. **NO uses esto en producción** - Solo para desarrollo y testing

## Entidades incluidas

Los seeders crean datos de prueba para las siguientes entidades:

1. **Countries** - 5 países con estados y ciudades
2. **Users/Customers** - 10 usuarios registrados y clientes
3. **Inventory** - 10 categorías, 10 proveedores y 12 productos
4. **Payment Methods** - 10 métodos de pago diferentes
5. **Posts** - 12 posts/artículos de blog
6. **Sells** - 15 ventas con productos y clientes

## Datos generados

Cada seeder genera al menos 10 registros como se solicitó:

- **Countries**: 5 países con múltiples estados y ciudades (más de 10 elementos en total)
- **Users**: 10 usuarios registrados + 10 usuarios simples + 10 clientes
- **Categories**: 10 categorías de productos
- **Providers**: 10 proveedores
- **Products**: 12 productos con diferentes categorías y proveedores
- **Payment Methods**: 10 métodos de pago (tarjetas, gift cards, etc.)
- **Posts**: 12 artículos de blog
- **Sells**: 15 ventas completas con productos y clientes

## Uso

### Método 1: Comando NPM (Recomendado)

```bash
npm run seed
```

### Método 2: Manualmente

```bash
ts-node -r tsconfig-paths/register src/scripts/seed.ts
```

### Para producción

```bash
# Primero compilar
npm run build

# Luego ejecutar el seeder compilado
npm run seed:prod
```

## Requisitos

1. **Base de datos MongoDB** configurada y funcionando
2. **Variables de entorno** configuradas correctamente:
   - `MONGODB_URI`: URI de conexión a MongoDB

## Orden de ejecución

Los seeders se ejecutan en el siguiente orden debido a las dependencias:

1. Countries
2. Users/Customers
3. Inventory (Categories, Providers, Products)
4. Payment Methods
5. Posts
6. Sells

## Características

- **⚠️ Reset automático**: Los seeders eliminan todos los datos existentes antes de insertar
- **Datos realistas**: Los datos generados son coherentes y realistas
- **Relaciones**: Se mantienen las relaciones entre entidades
- **UUIDs**: Se utilizan UUIDs para los IDs únicos
- **Manejo de errores**: Manejo robusto de errores durante el seeding

## Flujo de ejecución

1. **Reset de base de datos**: Elimina todos los datos de las colecciones
2. **Seeding ordenado**: Inserta datos respetando dependencias:
   - Countries → Users/Customers → Inventory → Payment Methods → Posts → Sells

## Estructura de archivos

```
src/database/
├── seeders/
│   ├── country.seeder.ts
│   ├── users.seeder.ts
│   ├── inventory.seeder.ts
│   ├── payments.seeder.ts
│   ├── posts.seeder.ts
│   ├── sells.seeder.ts
│   └── database.seeder.ts
├── database.module.ts
└── scripts/
    └── seed.ts
```

## Limpieza de base de datos

**Ya no es necesario limpiar manualmente** - los seeders ahora resetean automáticamente toda la base de datos antes de insertar los nuevos datos.

Si por algún motivo necesitas limpiar manualmente, puedes usar:

```javascript
// En MongoDB shell o cliente
db.countries.deleteMany({})
db.users.deleteMany({})
db.customers.deleteMany({})
db.categories.deleteMany({})
db.providers.deleteMany({})
db.products.deleteMany({})
db.paymentmethods.deleteMany({})
db.posts.deleteMany({})
db.sells.deleteMany({})
```