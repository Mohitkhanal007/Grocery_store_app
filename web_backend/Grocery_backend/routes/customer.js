const express = require("express");
const router = express.Router();
const { protect, authorize } = require("../middleware/auth");
const upload = require("../middleware/uploads");

const {
    getCustomers,
    getCustomerById,
    register,
    login,
    uploadImage,
    updateCustomer,
    updateCustomerProfile,
    deactivateCustomer,
    activateCustomer,
    getCustomerStats
} = require("../controllers/customer");
const customerController = require("../controllers/customer");

// Public routes
router.post("/register", upload.single("profilePicture"), register);
router.post("/login", login);

// Admin routes
router.get("/", protect, authorize("admin"), getCustomers);
router.get("/stats", protect, authorize("admin"), getCustomerStats);
router.get("/:id", protect, authorize("admin"), getCustomerById);
router.put("/:id", protect, authorize("admin"), upload.single("profilePicture"), updateCustomerProfile);
router.put("/:id/deactivate", protect, authorize("admin"), deactivateCustomer);
router.put("/:id/activate", protect, authorize("admin"), activateCustomer);

// User routes (existing)
router.get("/getAllCustomers", protect, authorize("admin"), getCustomers);
router.get("/getCustomer/:id", protect, authorize("admin", "customer"), getCustomerById);
router.put("/updateCustomer/:id", protect, authorize("admin", "customer"), upload.single("profilePicture"), updateCustomer);
router.post("/uploadImage", protect, authorize("admin", "customer"), upload.single("profilePicture"), uploadImage);

// Address management routes
router.post("/address", customerController.addAddress);
router.get("/addresses/:userId", customerController.getAddresses);
router.put("/address", customerController.updateAddress);
router.delete("/address", customerController.deleteAddress);

module.exports = router;