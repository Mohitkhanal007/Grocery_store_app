# 🔔 Notification System Guide

## 📱 When Users Receive Notifications

Since your Flutter app is **user-focused** (no admin interface), here are the realistic notification scenarios:

### 1. **Cart-Related Notifications** 🛒
**✅ IMPLEMENTED**

Users will receive notifications when:

#### **Add to Cart**
- **Trigger:** User adds item to cart
- **Message:** `"Added [QUANTITY]x [PRODUCT_NAME] to your cart"`
- **When:** Immediately after adding item

#### **Remove from Cart**
- **Trigger:** User removes item from cart
- **Message:** `"Removed [QUANTITY]x [PRODUCT_NAME] from your cart"`
- **When:** Immediately after removing item

#### **Cart Reminders**
- **Trigger:** Items left in cart for too long
- **Message:** `"You have [COUNT] item(s) in your cart! Don't forget to complete your purchase."`
- **When:** Scheduled reminders

#### **Cart Total Updates**
- **Trigger:** Cart total changes
- **Message:** `"Your cart total has been updated: [REASON] ([OLD_TOTAL] → [NEW_TOTAL])"`
- **When:** When total changes due to quantity, shipping, etc.

### 2. **Promotional Notifications** 🎉
**✅ IMPLEMENTED**

#### **Bulk Promotional Messages**
- **Trigger:** Manual API call to send promotional messages
- **Examples:**
  - `"🎉 Special Offer! Get 20% off on all jerseys this weekend!"`
  - `"⚽ New arrivals! Check out the latest team jerseys"`
  - `"🔥 Flash Sale! Limited time offers on premium jerseys"`

### 3. **Test Notifications** 🧪
**✅ AVAILABLE**

- **Purpose:** Testing the notification system
- **Usage:** Send custom test messages to specific users

## 🚀 How to Test Notifications

### **Method 1: Using the Test Scripts**
```bash
cd jersey_backend
node test-notifications.js
node test-cart-notifications.js
```

### **Method 2: Manual API Calls**

#### **Send Promotional Notification to All Users**
```bash
curl -X POST http://localhost:5050/api/notifications/promotional \
  -H "Content-Type: application/json" \
  -d '{
    "message": "🎉 Special Offer! Get 20% off on all jerseys this weekend!",
    "type": "promotion"
  }'
```

#### **Send Test Notification to Specific User**
```bash
curl -X POST http://localhost:5050/api/notifications/test \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID_HERE",
    "message": "🧪 This is a test notification!",
    "type": "alert"
  }'
```

#### **Test Cart Notifications**
```bash
# Add to cart notification
curl -X POST http://localhost:5050/api/cart/add-notification \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID_HERE",
    "productName": "Manchester United Home Jersey",
    "quantity": 2
  }'

# Remove from cart notification
curl -X POST http://localhost:5050/api/cart/remove-notification \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID_HERE",
    "productName": "Liverpool Away Jersey",
    "quantity": 1
  }'

# Cart reminder notification
curl -X POST http://localhost:5050/api/cart/reminder-notification \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID_HERE",
    "itemCount": 3
  }'
```

## 📋 Notification Types

| Type | Description | Use Case |
|------|-------------|----------|
| `cart` | Cart-related notifications | Add/remove items, cart updates |
| `reminder` | Reminder notifications | Cart reminders, scheduled alerts |
| `promotion` | Promotional messages | Sales, offers, new arrivals |
| `alert` | System alerts | Test messages, important updates |

## 🔧 Technical Implementation

### **Backend Changes Made:**

1. **cartController.js** - Added notifications for:
   - Add to cart actions
   - Remove from cart actions
   - Cart reminders
   - Cart total updates

2. **notificationController.js** - Added:
   - Promotional notification function
   - Bulk user notification support

3. **cartRoutes.js** - Added:
   - Cart notification endpoints

4. **notificationRoutes.js** - Added:
   - Promotional notification endpoint

### **Frontend Features:**

1. **Real-time WebSocket connection**
2. **Notification badge in bottom navigation**
3. **Notification list with mark-as-read functionality**
4. **Proper provider scoping (fixed)**

## 🎯 User Experience

### **Notification Badge:**
- Shows unread count in bottom navigation
- Updates in real-time
- Positioned on notification icon

### **Notification List:**
- Shows all notifications (newest first)
- Mark as read functionality
- Pull-to-refresh support
- Empty state handling

## 🔮 Future Enhancements

### **Potential Additions:**

1. **Payment Notifications**
   - Payment successful
   - Payment failed
   - Refund processed

2. **Inventory Notifications**
   - Back-in-stock alerts
   - Low stock warnings

3. **Personalized Notifications**
   - Birthday offers
   - Personalized recommendations

4. **System Notifications**
   - App updates
   - Maintenance notices

## 🧪 Testing Checklist

- [ ] Add to cart triggers notification
- [ ] Remove from cart triggers notification
- [ ] Cart reminders work properly
- [ ] Cart total updates trigger notifications
- [ ] Promotional notifications work
- [ ] Notification badge updates correctly
- [ ] Mark as read functionality works
- [ ] Real-time updates via WebSocket
- [ ] Notification list displays correctly

## 📞 Support

If you need help with notifications:
1. Check the backend logs for WebSocket connections
2. Verify the notification endpoints are working
3. Test with the provided test script
4. Ensure the Flutter app is connected to the WebSocket

---

**Note:** The notification system is now fully functional for user-focused scenarios. Users will receive real-time notifications for orders and promotional messages! 