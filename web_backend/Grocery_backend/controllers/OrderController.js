const Order = require("../models/Order");
const Customer = require("../models/Customer");
const Product = require("../models/Product");
const mongoose = require("mongoose");

// Create a new order
exports.createOrder = async (req, res) => {
  try {
    const { userId, items, address, total, paymentMethod, paymentId } = req.body;
    
    // Handle demo users - create a special userId for them
    let actualUserId = userId;
    if (userId && (userId.includes('demo-user') || userId.includes('demo'))) {
      // For demo users, create a special MongoDB ObjectId
      actualUserId = new mongoose.Types.ObjectId();
      console.log(`Demo user order: ${userId} -> ${actualUserId}`);
    }
    
    const order = new Order({
      userId: actualUserId,
      items,
      address,
      total,
      paymentMethod,
      paymentId,
      status: paymentMethod === "cod" ? "Pending" : "Paid",
      // Store original userId for demo users
      originalUserId: userId.includes('demo') ? userId : undefined
    });
    await order.save();
    res.status(201).json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to create order", error: err.message });
  }
};

// Get all orders for a user
exports.getUserOrders = async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Handle demo users
    if (userId && (userId.includes('demo-user') || userId.includes('demo'))) {
      // For demo users, find orders by originalUserId
      const orders = await Order.find({ originalUserId: userId }).sort({ createdAt: -1 });
      console.log(`Found ${orders.length} orders for demo user: ${userId}`);
      res.json({ success: true, orders });
    } else {
      // For real users, find by userId
      const orders = await Order.find({ userId }).sort({ createdAt: -1 });
      console.log(`Found ${orders.length} orders for real user: ${userId}`);
      res.json({ success: true, orders });
    }
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to fetch orders", error: err.message });
  }
};

// Update order status (admin)
exports.updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status } = req.body;
    const order = await Order.findById(orderId);
    if (!order) return res.status(404).json({ success: false, message: "Order not found" });
    order.status = status;
    await order.save();
    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to update order status", error: err.message });
  }
};

// Update full order (admin)
exports.updateOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const update = req.body;
    const order = await Order.findByIdAndUpdate(orderId, update, { new: true });
    if (!order) return res.status(404).json({ success: false, message: "Order not found" });
    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to update order", error: err.message });
  }
};

// Analytics endpoint
exports.getAnalytics = async (req, res) => {
  try {
    // Total sales
    const totalSales = await Order.aggregate([
      { $group: { _id: null, total: { $sum: "$total" } } }
    ]);
    // Top products
    const topProducts = await Order.aggregate([
      { $unwind: "$items" },
      { $group: { _id: "$items.productId", title: { $first: "$items.title" }, totalSold: { $sum: "$items.quantity" } } },
      { $sort: { totalSold: -1 } },
      { $limit: 5 }
    ]);
    // User growth (users per month)
    const userGrowth = await Customer.aggregate([
      { $group: { _id: { $dateToString: { format: "%Y-%m", date: "$createdAt" } }, count: { $sum: 1 } } },
      { $sort: { _id: 1 } }
    ]);
    // Order counts by status
    const orderStatusCounts = await Order.aggregate([
      { $group: { _id: "$status", count: { $sum: 1 } } }
    ]);
    res.json({
      success: true,
      totalSales: totalSales[0]?.total || 0,
      topProducts,
      userGrowth,
      orderStatusCounts
    });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to fetch analytics", error: err.message });
  }
};

// Get all orders (admin)
exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find().sort({ createdAt: -1 });
    res.json({ success: true, orders });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to fetch all orders", error: err.message });
  }
};

// Get order by ID
exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: "Order not found" });
    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to fetch order", error: err.message });
  }
};

// Filter/search orders (by status, user, date)
exports.filterOrders = async (req, res) => {
  try {
    const { status, userId, startDate, endDate } = req.query;
    let filter = {};
    if (status) filter.status = status;
    if (userId) filter.userId = userId;
    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }
    const orders = await Order.find(filter).sort({ createdAt: -1 });
    res.json({ success: true, orders });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to filter orders", error: err.message });
  }
}; 