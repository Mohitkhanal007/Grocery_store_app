const PaymentValidation = (req, res, next) => {
    const { amount, method, bookingId } = req.body;
    
    if (!amount || amount <= 0) {
        return res.status(400).json({ 
            success: false, 
            message: "Amount is required and must be greater than 0" 
        });
    }
    
    if (!method) {
        return res.status(400).json({ 
            success: false, 
            message: "Payment method is required" 
        });
    }
    
    if (!bookingId) {
        return res.status(400).json({ 
            success: false, 
            message: "Booking ID is required" 
        });
    }
    
    next();
};

module.exports = PaymentValidation; 