const express = require("express")
const router = express.Router();
const { 
    findAll, 
    save, 
    findById, 
    deleteById, 
    update, 
    filterPayments, 
    getPaymentStats 
} = require("../controllers/PaymentController");
const PackageValidation = require("../validation/PaymentValidation");

// Get all payments with filtering
router.get("/", findAll);

// Get payment statistics
router.get("/stats", getPaymentStats);

// Filter/search payments
router.get("/filter/search", filterPayments);

// Create new payment
router.post("/", PackageValidation, save);

// Get payment by ID
router.get("/:id", findById);

// Update payment
router.put("/:id", update);

// Delete payment
router.delete("/:id", deleteById);

module.exports = router;
