const express = require("express");
const router = express.Router();
const OrderController = require("../controllers/OrderController");

// Create a new order
router.post("/", OrderController.createOrder);

// Get all orders for a user
router.get("/user/:userId", OrderController.getUserOrders);

// Update order status (admin)
router.put('/:orderId/status', OrderController.updateOrderStatus);

// Update full order (admin)
router.put('/:orderId', OrderController.updateOrder);

// Analytics endpoint
router.get('/analytics', OrderController.getAnalytics);

// Filter/search orders
router.get('/filter/search', OrderController.filterOrders);
// Get order by ID
router.get('/:id', OrderController.getOrderById);

// Get all orders (admin) - keep this last
router.get('/', OrderController.getAllOrders);

module.exports = router; 