#!/bin/bash

echo "🚀 Starting Grocery Store Development Environment"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Node.js is installed
if ! command_exists node; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if Flutter is installed
if ! command_exists flutter; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if MongoDB is running
if ! pgrep -x "mongod" > /dev/null; then
    echo "⚠️  MongoDB is not running. Starting MongoDB..."
    mongod --fork --logpath /tmp/mongod.log
    if [ $? -ne 0 ]; then
        echo "❌ Failed to start MongoDB. Please start MongoDB manually."
        exit 1
    fi
fi

echo "✅ MongoDB is running"

# Start backend
echo "🔧 Starting Backend Server..."
cd web_api_backend-main/grocery_store_backend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing backend dependencies..."
    npm install
fi

# Start backend in background
echo "🚀 Starting backend on http://localhost:3001"
npm start &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Check if backend started successfully
if curl -s http://localhost:3001/api/v1/products > /dev/null; then
    echo "✅ Backend is running successfully"
else
    echo "❌ Backend failed to start. Check the logs above."
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

# Start Flutter app
echo "📱 Starting Flutter App..."
cd ../../mobile\ app

# Get Flutter dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Start Flutter app
echo "🚀 Starting Flutter app..."
flutter run

# Cleanup function
cleanup() {
    echo "🛑 Shutting down development environment..."
    kill $BACKEND_PID 2>/dev/null
    echo "✅ Development environment stopped"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Wait for user to stop
echo "Press Ctrl+C to stop the development environment"
wait 