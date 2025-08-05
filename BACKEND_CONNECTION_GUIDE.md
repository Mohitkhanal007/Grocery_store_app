# 🚀 Flutter + Node.js Backend Connection Guide

## 📋 Overview
This guide will help you connect your Flutter frontend with your Node.js backend API for the Grocery Store app.

## 🔧 Backend Configuration

### 1. Start Your Node.js Backend

Navigate to your backend directory and start the server:

```bash
cd web_backend/Grocery_backend
npm install  # Install dependencies if not already done
npm run dev  # Start development server
```

Your backend will run on: `http://192.168.16.109:5000`

### 2. Verify Backend is Running

You should see output like:
```
Server running in development mode on port 5000
```

## 🔗 Flutter Configuration

### 1. Backend Connection Settings

The Flutter app is configured to connect to your Node.js backend:

- **Server Address**: `http://192.168.16.109:5000`
- **API Base Path**: `/api/v1`
- **Full Base URL**: `http://192.168.16.109:5000/api/v1/`

### 2. Updated Configuration Files

✅ **Backend Config** (`lib/app/constant/backend_config.dart`)
- Updated to connect to Node.js backend on port 5000
- Configured API endpoints for grocery products
- Increased timeout for better connectivity

✅ **Product API Model** (`lib/features/product/data/model/product_api_model.dart`)
- Updated to match Node.js backend data structure
- Maps grocery product fields (name, category, price, etc.)
- Maintains compatibility with existing Flutter UI

✅ **Product Remote Data Source** (`lib/features/product/data/data_source/remote_datasource/product_remote_datasource.dart`)
- Enabled real API calls to Node.js backend
- Falls back to mock data if backend is unavailable
- Added detailed logging for debugging

## 🧪 Testing the Connection

### 1. Run Connection Tests

Start your Flutter app and tap the "Test Backend Connection" button on the splash screen (debug mode only).

You should see output like:
```
🚀 Starting connection tests...
🔗 Testing connection to Node.js backend...
✅ Backend connection successful!
📡 Response: {success: true, message: "Node.js backend is connected to Flutter app!"}
🔗 Testing products endpoint...
✅ Products endpoint working!
📦 Found 5 products
📊 Test Results:
   Backend Connection: ✅ PASS
   Products Endpoint: ✅ PASS
🎉 All tests passed! Flutter app is connected to Node.js backend.
```

### 2. Manual API Testing

You can also test the API endpoints directly:

```bash
# Test connection
curl http://192.168.16.109:5000/api/v1/test

# Get all products
curl http://192.168.16.109:5000/api/v1/products
```

## 📱 Flutter App Features

### 1. Product Fetching
- ✅ Real-time product data from Node.js backend
- ✅ Automatic fallback to mock data if backend unavailable
- ✅ Product categories, prices, stock quantities
- ✅ Product images and descriptions

### 2. Data Mapping
The Flutter app maps Node.js backend data to display properly:

| Node.js Field | Flutter Display |
|---------------|-----------------|
| `name` | Product Name |
| `category` | Product Type |
| `price` | Price |
| `stockQuantity` | Available Quantity |
| `unit` | Size/Unit |
| `image` | Product Image |

### 3. Error Handling
- ✅ Connection timeout handling
- ✅ Network error fallbacks
- ✅ Detailed error logging
- ✅ Graceful degradation to mock data

## 🔧 Troubleshooting

### 1. Connection Issues

**Problem**: Flutter app can't connect to backend
**Solutions**:
- Verify backend is running: `npm run dev`
- Check IP address in `backend_config.dart`
- Ensure firewall allows port 5000
- Test with curl: `curl http://192.168.16.109:5000/api/v1/test`

### 2. CORS Issues

**Problem**: CORS errors in browser/Flutter
**Solution**: Backend CORS is configured to allow Flutter connections

### 3. Data Mapping Issues

**Problem**: Products not displaying correctly
**Solution**: Check the mapping in `ProductApiModel.toEntity()`

### 4. Timeout Issues

**Problem**: API calls timing out
**Solution**: Increased timeout to 10 seconds in `backend_config.dart`

## 🚀 Next Steps

### 1. Add More Features
- User authentication with Node.js backend
- Order management
- Payment processing
- Real-time notifications

### 2. Production Deployment
- Deploy Node.js backend to cloud (Heroku, AWS, etc.)
- Update Flutter app with production backend URL
- Add SSL certificates
- Implement proper error handling

### 3. Database Integration
- Connect Node.js backend to MongoDB
- Add product management admin panel
- Implement user registration/login

## 📊 Current Status

✅ **Backend Connection**: Configured and tested
✅ **Product API**: Working with real data
✅ **Error Handling**: Implemented with fallbacks
✅ **CORS**: Configured for Flutter
✅ **Data Mapping**: Grocery products properly mapped
✅ **Testing**: Connection tests implemented

## 🎯 Success Indicators

Your Flutter app is successfully connected to Node.js backend when:

1. ✅ Backend server is running on port 5000
2. ✅ Flutter app can fetch products from `/api/v1/products`
3. ✅ Connection test passes in debug mode
4. ✅ Products display with real data from backend
5. ✅ No CORS or network errors in console

## 📞 Support

If you encounter issues:

1. Check the console logs for detailed error messages
2. Verify backend is running and accessible
3. Test API endpoints manually with curl
4. Check network connectivity between Flutter and backend

---

**🎉 Congratulations!** Your Flutter frontend is now connected to your Node.js backend and ready to serve real grocery store data! 