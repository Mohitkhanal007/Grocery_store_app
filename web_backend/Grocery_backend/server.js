const path = require("path");
const express = require("express");
const dotenv = require("dotenv");
const morgan = require("morgan");
const colors = require("colors");
const connectDB = require("./config/db");
const cookieParser = require("cookie-parser");
const mongoSanitize = require("express-mongo-sanitize"); // for sql injection
const helmet = require("helmet");
const xss = require("xss-clean");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();

app.use(cors({
  origin: [
    'http://localhost:5173', 
    'http://localhost:5174', 
    'http://127.0.0.1:5173', 
    'http://127.0.0.1:5174',
    'http://localhost:3000',
    'http://127.0.0.1:3000',
    'http://192.168.16.109:3000',
    'http://192.168.16.109:5173',
    'http://192.168.16.109:5174',
    // Allow Flutter app connections
    'http://192.168.16.109:5000',
    'http://10.0.2.2:5000', // Android emulator
    'http://localhost:5000',
    'http://127.0.0.1:5000'
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'x-auth-token']
}));
app.options("*", cors());
// Load env file
dotenv.config({
    path: "./config/config.env",
});

// Connect to database
connectDB();

// Route files
const auth = require("./routes/AuthRoute");
const customer = require("./routes/customer");
const product = require("./routes/ProductRoute");
const wishlist = require("./routes/WishlistRoute");
const khaltiRoutes = require("./routes/KhaltiRoute");
const booking = require("./routes/BookingRoute");
const orderRoute = require("./routes/OrderRoute");
const paymentRoute = require("./routes/PaymentRoute");

// Body parser
app.use(express.json());
app.use(cookieParser());

app.use(bodyParser.json({}));
app.use(bodyParser.urlencoded({ extended: true }));

// Dev logging middleware
if (process.env.NODE_ENV === "development") {
    app.use(morgan("dev"));
}

// Sanitize data
app.use(mongoSanitize());

// Set security headers
app.use(helmet());

// Prevent XSS attacks
app.use(xss());
app.use((req, res, next) => {
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
    res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
    res.setHeader('Cross-Origin-Embedder-Policy', 'require-corp');
    next();
});


// Set static folder
app.use(express.static(path.join(__dirname, 'public')));

// app.use(express.static('public'));

// Mount routers
app.use("/api/v1/auth", auth);
app.use("/api/v1/customer", customer);
app.use("/api/v1/products", product);
app.use("/api/v1/wishlist", wishlist);
app.use("/api/khalti", khaltiRoutes);
app.use("/api/v1/bookings", booking);
app.use("/api/v1/orders", orderRoute);
app.use("/api/v1/payments", paymentRoute);

// Test endpoint for Flutter app
app.get("/api/v1/test", (req, res) => {
  res.status(200).json({
    success: true,
    message: "Node.js backend is connected to Flutter app!",
    timestamp: new Date().toISOString()
  });
});


const PORT = process.env.PORT || 5000;

const server = app.listen(
    PORT,
    console.log(
        `Server running in ${process.env.NODE_ENV} mode on port ${PORT}`.yellow.bold
    )
);

// Handle unhandled promise rejections
process.on("unhandledRejection", (err, promise) => {
    console.log(`Error: ${err.message}`.red);
    // Close server & exit process
    server.close(() => process.exit(1));
});