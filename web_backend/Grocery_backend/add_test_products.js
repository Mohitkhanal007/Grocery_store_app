const mongoose = require('mongoose');
const Product = require('./models/Product');

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/grocery_store', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const testProducts = [
  {
    name: 'Fresh Milk',
    description: 'Organic whole milk from local farms',
    category: 'Milk',
    price: 3.99,
    stockQuantity: 50,
    unit: 'liter',
    brand: 'Local Dairy',
    isOrganic: true,
    isAvailable: true,
    expiryDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
    nutritionalInfo: {
      calories: 150,
      protein: 8,
      fat: 8,
      carbohydrates: 12,
      calcium: 300
    }
  },
  {
    name: 'Cheddar Cheese',
    description: 'Aged cheddar cheese, perfect for cooking',
    category: 'Cheese',
    price: 5.99,
    stockQuantity: 30,
    unit: 'pack',
    brand: 'Cheese Masters',
    isOrganic: false,
    isAvailable: true,
    expiryDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000), // 14 days from now
    nutritionalInfo: {
      calories: 400,
      protein: 25,
      fat: 33,
      carbohydrates: 1,
      calcium: 700
    }
  },
  {
    name: 'Greek Yogurt',
    description: 'Thick and creamy Greek yogurt',
    category: 'Yogurt',
    price: 4.49,
    stockQuantity: 40,
    unit: 'pack',
    brand: 'Yogurt Delight',
    isOrganic: true,
    isAvailable: true,
    expiryDate: new Date(Date.now() + 10 * 24 * 60 * 60 * 1000), // 10 days from now
    nutritionalInfo: {
      calories: 130,
      protein: 15,
      fat: 4,
      carbohydrates: 9,
      calcium: 200
    }
  },
  {
    name: 'Butter',
    description: 'Unsalted butter for cooking and baking',
    category: 'Butter',
    price: 2.99,
    stockQuantity: 25,
    unit: 'pack',
    brand: 'Butter Fresh',
    isOrganic: false,
    isAvailable: true,
    expiryDate: new Date(Date.now() + 21 * 24 * 60 * 60 * 1000), // 21 days from now
    nutritionalInfo: {
      calories: 717,
      protein: 0.9,
      fat: 81,
      carbohydrates: 0.1,
      calcium: 24
    }
  },
  {
    name: 'Vanilla Ice Cream',
    description: 'Creamy vanilla ice cream',
    category: 'Ice Cream',
    price: 6.99,
    stockQuantity: 20,
    unit: 'pack',
    brand: 'Ice Cream Co',
    isOrganic: false,
    isAvailable: true,
    expiryDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
    nutritionalInfo: {
      calories: 250,
      protein: 4,
      fat: 14,
      carbohydrates: 28,
      calcium: 150
    }
  }
];

async function addTestProducts() {
  try {
    console.log('🚀 Adding test products to database...');
    
    // Clear existing products
    await Product.deleteMany({});
    console.log('✅ Cleared existing products');
    
    // Add new products
    const addedProducts = await Product.insertMany(testProducts);
    console.log(`✅ Added ${addedProducts.length} test products:`);
    
    addedProducts.forEach(product => {
      console.log(`   - ${product.name} (${product.category}) - $${product.price}`);
    });
    
    console.log('\n🎉 Test products added successfully!');
    console.log('📱 Your Flutter app should now show these products');
    
  } catch (error) {
    console.error('❌ Error adding test products:', error);
  } finally {
    mongoose.connection.close();
  }
}

// Run the script
addTestProducts(); 