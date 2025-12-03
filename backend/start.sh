#!/bin/sh

echo "Waiting for MongoDB to be ready..."

# Wait for MongoDB to be ready
until node -e "const { MongoClient } = require('mongodb'); MongoClient.connect(process.env.MONGODB_URI || 'mongodb://mongo:27017/ecommerce_db').then(() => { console.log('MongoDB is ready'); process.exit(0); }).catch(() => { process.exit(1); });"; do
  echo "MongoDB is not ready yet, waiting..."
  sleep 2
done

echo "MongoDB is ready!"

# Check if database has data (check if users collection has documents)
HAS_DATA=$(node -e "const { MongoClient } = require('mongodb'); MongoClient.connect(process.env.MONGODB_URI || 'mongodb://mongo:27017/ecommerce_db').then(async client => { const db = client.db(); const count = await db.collection('users').countDocuments(); console.log(count); client.close(); }).catch(() => console.log('0'));" 2>/dev/null)

echo "Found $HAS_DATA users in database"

# Run seeder only if database is empty
if [ "$HAS_DATA" = "0" ]; then
  echo "Database is empty, running seeder..."
  npm run seed:prod
  echo "Seeder completed!"
else
  echo "Database already has data, skipping seeder"
fi

# Start the application
echo "Starting NestJS application..."
dumb-init npm run start:prod