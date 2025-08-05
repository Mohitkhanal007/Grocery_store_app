const mongoose = require("mongoose");

const OrderItemSchema = new mongoose.Schema({
  productId: { type: mongoose.Schema.Types.ObjectId, ref: "Product", required: true },
  title: String,
  price: Number,
  quantity: Number,
  image: String
});

const AddressSchema = new mongoose.Schema({
  street: String,
  city: String,
  state: String,
  zip: String,
  country: String
});

const OrderSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "Customer", required: true },
  originalUserId: { type: String }, // For demo users
  items: [OrderItemSchema],
  address: AddressSchema,
  total: Number,
  paymentMethod: String,
  paymentId: String,
  status: { type: String, default: "Pending" },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Order", OrderSchema); 