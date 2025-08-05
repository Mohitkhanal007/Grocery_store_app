const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const SECRET_KEY = "d2f78ec5c4eb64c0bfe582ae6228a6059806a082724c9193836754dd3b8f14c4"
const Credential = require("../models/Credential")
const Customer = require("../models/Customer")

const register = async (req, res) => {
    try {
        const { username, password, role } = req.body;
        
        // Check if user already exists
        const existingUser = await Credential.findOne({ username });
        if (existingUser) {
            return res.status(400).json({ message: "User already exists" });
        }
        
        const hashedPassword = await bcrypt.hash(password, 10);
        const cred = new Credential({ username, password: hashedPassword, role });
        await cred.save();
        
        res.status(201).json({
            message: "User registered successfully",
            user: {
                username: cred.username,
                role: cred.role,
                userId: cred._id
            }
        });
    } catch (error) {
        console.error("Registration error:", error);
        res.status(500).json({ message: "Registration failed", error: error.message });
    }
};

const login = async (req, res) => {
    try {
        const { username, password } = req.body;
        
        console.log("Login attempt received:", { username, password: password ? "***" : "undefined" });
        console.log("Full request body:", req.body);
        
        if (!username || !password) {
            console.log("Missing username or password");
            return res.status(400).json({ message: "Please provide username and password" });
        }
        
        // First check in creds collection
        let cred = await Credential.findOne({ username });
        let userType = 'creds';
        
        // If not found in creds, check in customers collection
        if (!cred) {
            cred = await Customer.findOne({ email: username });
            userType = 'customers';
        }
        
        console.log("User found in DB:", cred ? "Yes" : "No");
        console.log("User type:", userType);
        
        if (!cred) {
            console.log("User not found");
            return res.status(403).json({ message: 'Invalid username or password' });
        }
        
        // Check password
        let isValidPassword = false;
        if (userType === 'creds') {
            isValidPassword = await bcrypt.compare(password, cred.password);
        } else {
            isValidPassword = await cred.matchPassword(password);
        }
        
        if (!isValidPassword) {
            console.log("Invalid password");
            return res.status(403).json({ message: 'Invalid username or password' });
        }

        console.log("Login successful for user:", username);
        const token = jwt.sign({ 
            username: userType === 'creds' ? cred.username : cred.email, 
            role: cred.role 
        }, SECRET_KEY, { expiresIn: '1h' });
        
        res.json({ 
            token,
            username: userType === 'creds' ? cred.username : cred.email,
            role: cred.role,
            userId: cred._id
        });
    } catch (error) {
        console.error("Login error:", error);
        res.status(500).json({ message: "Login failed", error: error.message });
    }
};
module.exports = {
    login,
    register
}