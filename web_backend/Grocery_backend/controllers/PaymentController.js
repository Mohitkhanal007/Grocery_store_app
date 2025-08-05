const Payment = require('../models/Payment')
const Order = require('../models/Order')

// @desc    Get all payments
// @route   GET /api/v1/payments
// @access  Private (Admin)
const findAll = async (req, res) => {
    try {
        const { page = 1, limit = 10, status, method, startDate, endDate } = req.query;
        
        let query = {};
        
        // Filter by status
        if (status) {
            query.status = status;
        }
        
        // Filter by payment method
        if (method) {
            query.method = method;
        }
        
        // Filter by date range
        if (startDate || endDate) {
            query.date = {};
            if (startDate) query.date.$gte = new Date(startDate);
            if (endDate) query.date.$lte = new Date(endDate);
        }
        
        const payments = await Payment.find(query)
            .populate('bookingId')
            .sort({ date: -1 })
            .limit(limit * 1)
            .skip((page - 1) * limit);
            
        const total = await Payment.countDocuments(query);
        
        res.status(200).json({
            success: true,
            count: payments.length,
            total,
            totalPages: Math.ceil(total / limit),
            currentPage: page,
            data: payments
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error fetching payments",
            error: error.message 
        });
    }
}

// @desc    Create new payment
// @route   POST /api/v1/payments
// @access  Private
const save = async (req, res) => {
    try {
        const { amount, method, status, bookingId } = req.body;
        
        const payment = new Payment({
            amount,
            method,
            status: status || 'pending',
            date: new Date(),
            bookingId
        });
        
        await payment.save();
        
        res.status(201).json({
            success: true,
            message: "Payment created successfully",
            data: payment
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error creating payment",
            error: error.message 
        });
    }
}

// @desc    Get payment by ID
// @route   GET /api/v1/payments/:id
// @access  Private (Admin)
const findById = async (req, res) => {
    try {
        const payment = await Payment.findById(req.params.id).populate('bookingId');
        
        if (!payment) {
            return res.status(404).json({ 
                success: false, 
                message: "Payment not found" 
            });
        }
        
        res.status(200).json({
            success: true,
            data: payment
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error fetching payment",
            error: error.message 
        });
    }
}

// @desc    Delete payment by ID
// @route   DELETE /api/v1/payments/:id
// @access  Private (Admin)
const deleteById = async (req, res) => {
    try {
        const payment = await Payment.findById(req.params.id);
        
        if (!payment) {
            return res.status(404).json({ 
                success: false, 
                message: "Payment not found" 
            });
        }
        
        await Payment.findByIdAndDelete(req.params.id);
        
        res.status(200).json({
            success: true,
            message: "Payment deleted successfully"
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error deleting payment",
            error: error.message 
        });
    }
}

// @desc    Update payment
// @route   PUT /api/v1/payments/:id
// @access  Private (Admin)
const update = async (req, res) => {
    try {
        const payment = await Payment.findByIdAndUpdate(
            req.params.id, 
            req.body, 
            { new: true, runValidators: true }
        );
        
        if (!payment) {
            return res.status(404).json({ 
                success: false, 
                message: "Payment not found" 
            });
        }
        
        res.status(200).json({
            success: true,
            message: "Payment updated successfully",
            data: payment
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error updating payment",
            error: error.message 
        });
    }
}

// @desc    Filter/search payments
// @route   GET /api/v1/payments/filter/search
// @access  Private (Admin)
const filterPayments = async (req, res) => {
    try {
        const { 
            page = 1, 
            limit = 10, 
            status, 
            method, 
            startDate, 
            endDate, 
            minAmount, 
            maxAmount,
            userId,
            orderId
        } = req.query;
        
        let query = {};
        
        // Filter by status
        if (status) {
            query.status = status;
        }
        
        // Filter by payment method
        if (method) {
            query.method = method;
        }
        
        // Filter by date range
        if (startDate || endDate) {
            query.date = {};
            if (startDate) query.date.$gte = new Date(startDate);
            if (endDate) query.date.$lte = new Date(endDate);
        }
        
        // Filter by amount range
        if (minAmount || maxAmount) {
            query.amount = {};
            if (minAmount) query.amount.$gte = parseFloat(minAmount);
            if (maxAmount) query.amount.$lte = parseFloat(maxAmount);
        }
        
        // Filter by user (if bookingId references user orders)
        if (userId) {
            // This would need to be implemented based on your order structure
            // For now, we'll search in bookingId if it contains user info
        }
        
        // Filter by order
        if (orderId) {
            query.bookingId = orderId;
        }
        
        const payments = await Payment.find(query)
            .populate('bookingId')
            .sort({ date: -1 })
            .limit(limit * 1)
            .skip((page - 1) * limit);
            
        const total = await Payment.countDocuments(query);
        
        res.status(200).json({
            success: true,
            count: payments.length,
            total,
            totalPages: Math.ceil(total / limit),
            currentPage: parseInt(page),
            data: payments
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error filtering payments",
            error: error.message 
        });
    }
}

// @desc    Get payment statistics
// @route   GET /api/v1/payments/stats
// @access  Private (Admin)
const getPaymentStats = async (req, res) => {
    try {
        const stats = await Payment.aggregate([
            {
                $group: {
                    _id: null,
                    totalPayments: { $sum: 1 },
                    totalAmount: { $sum: "$amount" },
                    avgAmount: { $avg: "$amount" }
                }
            }
        ]);
        
        const statusStats = await Payment.aggregate([
            {
                $group: {
                    _id: "$status",
                    count: { $sum: 1 },
                    totalAmount: { $sum: "$amount" }
                }
            }
        ]);
        
        const methodStats = await Payment.aggregate([
            {
                $group: {
                    _id: "$method",
                    count: { $sum: 1 },
                    totalAmount: { $sum: "$amount" }
                }
            }
        ]);
        
        res.status(200).json({
            success: true,
            data: {
                overview: stats[0] || { totalPayments: 0, totalAmount: 0, avgAmount: 0 },
                byStatus: statusStats,
                byMethod: methodStats
            }
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: "Error fetching payment statistics",
            error: error.message 
        });
    }
}

module.exports = {
    findAll,
    save,
    findById,
    deleteById,
    update,
    filterPayments,
    getPaymentStats
}