const asyncHandler = require("../middleware/async");
const Customer = require("../models/Customer");
const { protect, authorize } = require("../middleware/auth"); // Import RBAC Middleware
const path = require("path");
const fs = require("fs");

// @desc    Get all customers (Admin Only)
// @route   GET /api/v1/customers
// @access  Private (Admin)
exports.getCustomers = asyncHandler(async (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied. Admins only." });
    }

    const { page = 1, limit = 10, search, status, role } = req.query;
    
    let query = {};
    
    // Search by name or email
    if (search) {
        query.$or = [
            { fname: { $regex: search, $options: 'i' } },
            { lname: { $regex: search, $options: 'i' } },
            { email: { $regex: search, $options: 'i' } }
        ];
    }
    
    // Filter by status (active/inactive)
    if (status) {
        query.status = status;
    }
    
    // Filter by role
    if (role) {
        query.role = role;
    }
    
    const customers = await Customer.find(query)
        .select('-password')
        .sort({ createdAt: -1 })
        .limit(limit * 1)
        .skip((page - 1) * limit);
        
    const total = await Customer.countDocuments(query);
    
    res.status(200).json({
        success: true,
        count: customers.length,
        total,
        totalPages: Math.ceil(total / limit),
        currentPage: parseInt(page),
        data: customers,
    });
});

// @desc    Get single customer by ID (Admin Only)
// @route   GET /api/v1/customers/:id
// @access  Private (Admin)
exports.getCustomerById = asyncHandler(async (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied. Admins only." });
    }

    const customer = await Customer.findById(req.params.id).select('-password');

    if (!customer) {
        return res.status(404).json({ message: `Customer not found with id ${req.params.id}` });
    }

    res.status(200).json({
        success: true,
        data: customer,
    });
});

// @desc    Update customer profile and status (Admin Only)
// @route   PUT /api/v1/customers/:id
// @access  Private (Admin)
exports.updateCustomerProfile = asyncHandler(async (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied. Admins only." });
    }

    let customer = await Customer.findById(req.params.id);
    
    if (!customer) {
        return res.status(404).json({ message: `Customer not found with id ${req.params.id}` });
    }

    const { fname, lname, phone, email, role, status } = req.body;
    let image = customer.image;

    // Check if a new image is uploaded
    if (req.file) {
        if (customer.image) {
            const imagePath = path.join(__dirname, "../public/uploads", customer.image);
            if (fs.existsSync(imagePath)) {
                fs.unlinkSync(imagePath);
            }
        }
        image = req.file.filename;
    }

    const updatedData = { fname, lname, phone, email, image, role, status };

    customer = await Customer.findByIdAndUpdate(req.params.id, updatedData, {
        new: true,
        runValidators: true,
    }).select('-password');

    res.status(200).json({
        success: true,
        message: "Customer updated successfully",
        data: customer,
    });
});

// @desc    Deactivate customer (Admin Only)
// @route   PUT /api/v1/customers/:id/deactivate
// @access  Private (Admin)
exports.deactivateCustomer = asyncHandler(async (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied. Admins only." });
    }

    const customer = await Customer.findById(req.params.id);

    if (!customer) {
        return res.status(404).json({ message: "Customer not found" });
    }

    // Set status to inactive instead of deleting
    customer.status = 'inactive';
    await customer.save();

    res.status(200).json({ 
        success: true, 
        message: "Customer deactivated successfully",
        data: customer
    });
});

// @desc    Activate customer (Admin Only)
// @route   PUT /api/v1/customers/:id/activate
// @access  Private (Admin)
exports.activateCustomer = asyncHandler(async (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied. Admins only." });
    }

    const customer = await Customer.findById(req.params.id);

    if (!customer) {
        return res.status(404).json({ message: "Customer not found" });
    }

    // Set status to active
    customer.status = 'active';
    await customer.save();

    res.status(200).json({ 
        success: true, 
        message: "Customer activated successfully",
        data: customer
    });
});

// @desc    Get customer statistics
// @route   GET /api/v1/customers/stats
// @access  Private (Admin)
exports.getCustomerStats = asyncHandler(async (req, res, next) => {
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied. Admins only." });
    }

    const stats = await Customer.aggregate([
        {
            $group: {
                _id: null,
                totalCustomers: { $sum: 1 },
                activeCustomers: {
                    $sum: { $cond: [{ $eq: ["$status", "active"] }, 1, 0] }
                },
                inactiveCustomers: {
                    $sum: { $cond: [{ $eq: ["$status", "inactive"] }, 1, 0] }
                }
            }
        }
    ]);

    const roleStats = await Customer.aggregate([
        {
            $group: {
                _id: "$role",
                count: { $sum: 1 }
            }
        }
    ]);

    const monthlyStats = await Customer.aggregate([
        {
            $group: {
                _id: {
                    year: { $year: "$createdAt" },
                    month: { $month: "$createdAt" }
                },
                count: { $sum: 1 }
            }
        },
        { $sort: { "_id.year": -1, "_id.month": -1 } },
        { $limit: 12 }
    ]);

    res.status(200).json({
        success: true,
        data: {
            overview: stats[0] || { totalCustomers: 0, activeCustomers: 0, inactiveCustomers: 0 },
            byRole: roleStats,
            monthlyGrowth: monthlyStats
        }
    });
});

// @desc    Register new customer
// @route   POST /api/v1/customers/register
// @access  Public
exports.register = asyncHandler(async (req, res, next) => {
    const { fname, lname, phone, email, password, role, image } = req.body;
    
    // Check if the user already exists
    const existingCustomer = await Customer.findOne({ email });
    if (existingCustomer) {
        return res.status(400).json({ message: "User already exists." });
    }

    // Create a new customer
    const customer = await Customer.create({
        fname,
        lname,
        phone,
        email,
        password,
        image,
        role: role || "customer", // Default role is "customer"
    });

    // Send response without token
    res.status(201).json({
        success: true,
        message: "Customer registered successfully",
    });
});


// @desc    Login customer
// @route   POST /api/v1/customers/login
// @access  Public
exports.login = asyncHandler(async (req, res, next) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Please provide an email and password" });
    }

    const customer = await Customer.findOne({ email }).select("+password");

    if (!customer || !(await customer.matchPassword(password))) {
        return res.status(401).json({ message: "Invalid credentials" });
    }

    sendTokenResponse(customer, 200, res);
});

// @desc    Update customer profile (Only Admin or the Customer Himself)
// @route   PUT /api/v1/customers/update/:id
// @access  Private (Admin or User)
exports.updateCustomer = asyncHandler(async (req, res, next) => {
    let customer = await Customer.findById(req.params.id);
    if (!customer) {
        return res.status(404).json({ message: `Customer not found with id ${req.params.id}` });
    }

    // Only allow update if admin or the customer himself
    if (req.user.role !== "admin" && req.user.id !== customer.id) {
        return res.status(403).json({ message: "Access denied." });
    }

    const { fname, lname, phone, email, role } = req.body;
    let image = customer.image;

    // Check if a new image is uploaded
    if (req.file) {
        if (customer.image) {
            const imagePath = path.join(__dirname, "../public/uploads", customer.image);
            if (fs.existsSync(imagePath)) {
                fs.unlinkSync(imagePath);
            }
        }
        image = req.file.filename;
    }

    // Only an admin can change the role
    const updatedData = req.user.role === "admin" ? { fname, lname, phone, email, image, role } : { fname, lname, phone, email, image };

    customer = await Customer.findByIdAndUpdate(req.params.id, updatedData, {
        new: true,
        runValidators: true,
    });

    res.status(200).json({
        success: true,
        message: "Customer updated successfully",
        data: customer,
    });
});

// @desc    Delete Customer (Admin Only)
// @route   DELETE /api/v1/customers/:id
// @access  Private (Admin Only)
exports.deleteCustomer = asyncHandler(async (req, res, next) => {
    const customer = await Customer.findById(req.params.id);

    if (!customer) {
        return res.status(404).json({ message: "Customer not found" });
    }

    // Only allow admin to delete customer
    if (req.user.role !== "admin") {
        return res.status(403).json({ message: "Access denied." });
    }

    await customer.remove();
    res.status(200).json({ success: true, message: "Customer deleted successfully" });
});

// @desc    Upload Single Image
// @route   POST /api/v1/customers/upload
// @access  Private (Only Logged-in Users)
exports.uploadImage = asyncHandler(async (req, res, next) => {
    if (!req.file) {
        return res.status(400).json({ message: "Please upload a file" });
    }

    res.status(200).json({
        success: true,
        message: "Image uploaded successfully",
        data: req.file.filename,
    });
});

// Add a new address
exports.addAddress = async (req, res) => {
  try {
    const { userId, address } = req.body;
    const customer = await Customer.findById(userId);
    if (!customer) return res.status(404).json({ success: false, message: "User not found" });
    customer.addresses.push(address);
    await customer.save();
    res.json({ success: true, addresses: customer.addresses });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to add address", error: err.message });
  }
};

// Get all addresses for a user
exports.getAddresses = async (req, res) => {
  try {
    const { userId } = req.params;
    const customer = await Customer.findById(userId);
    if (!customer) return res.status(404).json({ success: false, message: "User not found" });
    res.json({ success: true, addresses: customer.addresses });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to fetch addresses", error: err.message });
  }
};

// Update an address
exports.updateAddress = async (req, res) => {
  try {
    const { userId, addressId, address } = req.body;
    const customer = await Customer.findById(userId);
    if (!customer) return res.status(404).json({ success: false, message: "User not found" });
    const addr = customer.addresses.id(addressId);
    if (!addr) return res.status(404).json({ success: false, message: "Address not found" });
    Object.assign(addr, address);
    await customer.save();
    res.json({ success: true, addresses: customer.addresses });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to update address", error: err.message });
  }
};

// Delete an address
exports.deleteAddress = async (req, res) => {
  try {
    const { userId, addressId } = req.body;
    const customer = await Customer.findById(userId);
    if (!customer) return res.status(404).json({ success: false, message: "User not found" });
    customer.addresses.id(addressId).remove();
    await customer.save();
    res.json({ success: true, addresses: customer.addresses });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to delete address", error: err.message });
  }
};

// Get token from model, create cookie, and send response
const sendTokenResponse = (customer, statusCode, res) => {
    const token = customer.getSignedJwtToken();

    const options = {
        expires: new Date(Date.now() + process.env.JWT_COOKIE_EXPIRE * 24 * 60 * 60 * 1000),
        httpOnly: true,
    };

    if (process.env.NODE_ENV === "production") {
        options.secure = true;
    }

    res.status(statusCode)
        .cookie("token", token, options)
        .json({
            success: true,
            token,
            userId: customer._id,
            role: customer.role, // Include role in response
        });
};