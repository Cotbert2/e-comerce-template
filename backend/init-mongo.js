// MongoDB initialization script
// This script runs when the MongoDB container starts for the first time

// Switch to the ecommerce_db database
db = db.getSiblingDB('ecommerce_db');

// Create a user for the application (optional, for security)
db.createUser({
  user: 'ecommerce_user',
  pwd: 'ecommerce_password',
  roles: [
    {
      role: 'readWrite',
      db: 'ecommerce_db'
    }
  ]
});

// Create initial collections (optional)
db.createCollection('users');
db.createCollection('products');
db.createCollection('orders');
db.createCollection('categories');

print('Database and collections created successfully');