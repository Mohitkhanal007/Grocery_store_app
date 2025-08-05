#!/bin/bash

echo "🚀 Starting Grocery Store App (Flutter + Node.js)"
echo "================================================"

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

echo "✅ Node.js version: $(node --version)"
echo "✅ Flutter version: $(flutter --version | head -n 1)"

echo ""
echo "🔧 Starting Node.js Backend..."
echo "=============================="

# Navigate to backend directory
cd web_backend/Grocery_backend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
fi

# Start the backend server
echo "🚀 Starting backend server on port 5000..."
npm run dev &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Check if backend is running
if curl -s http://192.168.16.109:5000/api/v1/test > /dev/null; then
    echo "✅ Backend is running successfully!"
else
    echo "⚠️  Backend might not be fully started yet. Continuing..."
fi

echo ""
echo "📱 Starting Flutter App..."
echo "========================="

# Go back to root directory
cd ../..

# Check Flutter dependencies
echo "📦 Checking Flutter dependencies..."
flutter pub get

# Run Flutter app
echo "🚀 Starting Flutter app..."
echo ""
echo "💡 Tips:"
echo "   - Backend runs on: http://192.168.16.109:5000"
echo "   - Test connection in Flutter app using the debug button"
echo "   - Press Ctrl+C to stop both backend and frontend"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping services..."
    kill $BACKEND_PID 2>/dev/null
    echo "✅ Cleanup complete"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Start Flutter app
flutter run

# If Flutter exits, cleanup
cleanup 