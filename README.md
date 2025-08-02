# Grocery Store Mobile App

A Flutter mobile application connected to a Node.js backend for a grocery store e-commerce platform.

## Project Structure

```
mobile app/
├── lib/
│   ├── core/
│   │   ├── api_service.dart      # Product API calls
│   │   ├── auth_service.dart     # Authentication API calls
│   │   ├── cart_service.dart     # Cart API calls
│   │   ├── config.dart          # API configuration
│   │   └── product_provider.dart # State management
│   ├── model/
│   │   ├── product.dart         # Product data model
│   │   └── user_model.dart      # User data model
│   └── screens/                 # UI screens
├── web_api_backend-main/
│   └── grocery_store_backend/   # Node.js backend
└── assets/                      # Images and fonts
```

## Backend Setup

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (running locally or cloud instance)
- npm or yarn

### Installation

1. Navigate to the backend directory:
```bash
cd web_api_backend-main/grocery_store_backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
   - Copy `config/config.env` and update the values:
   ```env
   NODE_ENV=development
   PORT=3001
   LOCAL_DATABASE_URI='mongodb://127.0.0.1:27017/grocery_db'
   FILE_UPLOAD_PATH=./public/uploads
   MAX_FILE_UPLOAD=20000
   JWT_SECRET=your_jwt_secret_here
   JWT_EXPIRE=30d
   JWT_COOKIE_EXPIRE=30
   ```

4. Start MongoDB (if running locally):
```bash
mongod
```

5. Start the backend server:
```bash
npm start
```

The backend will run on `http://localhost:3001`

## Flutter App Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. Navigate to the Flutter app directory:
```bash
cd mobile app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Update API configuration (if needed):
   - Open `lib/core/config.dart`
   - Update `devBaseUrl` if your backend runs on a different port
   - For production, update `prodBaseUrl` with your server URL

4. Run the app:
```bash
flutter run
```

## API Integration

### Authentication
The app uses JWT tokens for authentication. The `AuthService` handles:
- User login
- User registration
- Profile management
- Logout

### Products
The `ApiService` provides methods for:
- Get all products
- Get products by category
- Get expiring products
- Create/Update/Delete products
- Update stock quantities

### Shopping Cart
The `CartService` handles:
- Add items to cart
- Update cart quantities
- Remove items from cart
- Get cart total
- Clear cart

## Key Features

### Backend Features
- ✅ User authentication (JWT)
- ✅ Product management (CRUD)
- ✅ Category-based filtering
- ✅ Stock management
- ✅ Expiry date tracking
- ✅ File upload for product images
- ✅ Shopping cart functionality
- ✅ Order management
- ✅ Wishlist functionality
- ✅ Review system

### Flutter App Features
- ✅ Modern UI with Material Design
- ✅ Product browsing and search
- ✅ Category filtering
- ✅ Shopping cart
- ✅ User authentication
- ✅ Profile management
- ✅ Responsive design

## API Endpoints

### Authentication
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/logout` - User logout

### Products
- `GET /api/v1/products` - Get all products
- `GET /api/v1/products/:id` - Get product by ID
- `POST /api/v1/products` - Create new product
- `PUT /api/v1/products/:id` - Update product
- `DELETE /api/v1/products/:id` - Delete product
- `GET /api/v1/products/category/:category` - Get products by category
- `GET /api/v1/products/expiring/soon` - Get expiring products
- `PUT /api/v1/products/:id/stock` - Update stock quantity

### Cart
- `GET /api/v1/cart` - Get user's cart
- `POST /api/v1/cart` - Add item to cart
- `PUT /api/v1/cart/:itemId` - Update cart item
- `DELETE /api/v1/cart/:itemId` - Remove item from cart
- `DELETE /api/v1/cart` - Clear cart
- `GET /api/v1/cart/total` - Get cart total

### User Profile
- `GET /api/v1/customers/profile` - Get user profile
- `PUT /api/v1/customers/profile` - Update user profile

## Data Models

### Product Model
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stockQuantity;
  final String unit;
  final String? image;
  final DateTime expiryDate;
  final String brand;
  final bool isOrganic;
  final bool isAvailable;
  final Map<String, dynamic>? nutritionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### User Model
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? address;
}
```

## State Management

The app uses Provider for state management:
- `ProductProvider` - Manages product data and operations
- Authentication state is managed through the auth service

## Configuration

### Backend Configuration
- Database: MongoDB
- Authentication: JWT
- File upload: Multer
- Security: Helmet, CORS, XSS protection

### Flutter Configuration
- HTTP client: `http` package
- State management: `provider` package
- Local storage: `hive` package
- UI: Material Design

## Troubleshooting

### Common Issues

1. **Backend connection failed**
   - Ensure MongoDB is running
   - Check if backend is running on port 3001
   - Verify network connectivity

2. **Authentication errors**
   - Check JWT token expiration
   - Verify user credentials
   - Ensure proper token storage

3. **Image upload issues**
   - Check file size limits
   - Verify supported file formats
   - Ensure upload directory exists

4. **Flutter build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

## Development

### Adding New Features

1. **Backend**: Add new routes in `routes/` directory
2. **Flutter**: Create corresponding service methods
3. **UI**: Add new screens in `screens/` directory
4. **State**: Update providers if needed

### Testing

1. **Backend**: Run `npm test` for API tests
2. **Flutter**: Run `flutter test` for widget tests

## Deployment

### Backend Deployment
1. Set up production MongoDB instance
2. Update environment variables
3. Deploy to cloud platform (Heroku, AWS, etc.)

### Flutter App Deployment
1. Update `prodBaseUrl` in config
2. Build for target platform:
   ```bash
   flutter build apk  # Android
   flutter build ios  # iOS
   ```

## License

This project is licensed under the MIT License.
