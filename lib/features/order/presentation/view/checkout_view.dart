import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/app/shared_prefs/user_shared_prefs.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:grocerystore/features/order/presentation/widgets/order_item_widget.dart';
import 'package:grocerystore/features/payment/presentation/view/payment_view.dart';
import 'package:grocerystore/features/payment/presentation/viewmodel/payment_viewmodel.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';

class CheckoutView extends StatefulWidget {
  final CartEntity cart;

  const CheckoutView({super.key, required this.cart});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  late final UserSharedPrefs _userSharedPrefs;

  @override
  void initState() {
    super.initState();
    _userSharedPrefs = serviceLocator<UserSharedPrefs>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<OrderViewModel, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            _showOrderSuccessDialog(state.order);
          } else if (state is OrderError) {
            _showErrorSnackBar(state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                const SizedBox(height: 24),
                _buildShippingForm(),
                const SizedBox(height: 24),
                _buildOrderItems(),
                const SizedBox(height: 24),
                _buildPlaceOrderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Subtotal',
              'रू${widget.cart.totalPrice.toStringAsFixed(2)}',
            ),
            _buildSummaryRow('Shipping', 'रू5.99'),
            const Divider(),
            _buildSummaryRow(
              'Total',
              'रू${(widget.cart.totalPrice + 5.99).toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? Theme.of(context).primaryColor
                  : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Shipping Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your shipping address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...widget.cart.items.map<Widget>(
              (item) => OrderItemWidget(item: item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _proceedToPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Proceed to Payment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _proceedToPayment() {
    if (_formKey.currentState!.validate()) {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final totalAmount = widget.cart.totalPrice + 5.99;

      // Navigate to payment page
      print('🔍 CheckoutView: Cart has ${widget.cart.items.length} items');
      print(
        '🔍 CheckoutView: Cart items: ${widget.cart.items.map((item) => '${item.product.team} - ${item.quantity}').join(', ')}',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<PaymentViewModel>(),
              ),
            ],
            child: PaymentView(
              orderId: orderId,
              amount: totalAmount,
              customerName: _nameController.text,
              customerEmail: _emailController.text,
              cartItems: widget.cart.items, // Pass cart items to PaymentView
              onPaymentSuccess: () {
                // This will be called when payment is successful
                _placeOrder(orderId);
              },
              onPaymentFailure: () {
                _showErrorSnackBar('Payment failed. Please try again.');
              },
            ),
          ),
        ),
      ).then((result) {
        // When payment screen is popped, check if payment was successful
        // For eSewa, we assume success if the screen is popped normally
        if (result == true) {
          _placeOrder(orderId);
        }
      });
    }
  }

  void _placeOrder(String orderId) {
    final userId = _userSharedPrefs.getCurrentUserId();

    final order = OrderEntity(
      id: orderId,
      userId: userId,
      items: widget.cart.items,
      subtotal: widget.cart.totalPrice,
      shippingCost: 5.99,
      totalAmount: widget.cart.totalPrice + 5.99,
      status: OrderStatus.pending,
      customerName: _nameController.text,
      customerEmail: _emailController.text,
      customerPhone: _phoneController.text,
      shippingAddress: _addressController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print('🔗 Creating order with userId: $userId');
    context.read<OrderViewModel>().add(CreateOrderEvent(order: order));
  }

  void _showOrderSuccessDialog(OrderEntity order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Placed Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order #${order.id.substring(0, 8)}'),
              const SizedBox(height: 8),
              Text('Total: रू${order.totalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              const Text(
                'Thank you for your order! You will receive a confirmation email shortly.',
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _clearCartAndNavigateToHome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Home'),
            ),
          ],
        );
      },
    );
  }

  void _clearCartAndNavigateToHome() {
    // Clear the cart
    final userId = _userSharedPrefs.getCurrentUserId();
    if (userId != null) {
      final cartViewModel = serviceLocator<CartViewModel>();
      cartViewModel.add(ClearCartEvent(userId: userId));
    }

    // Navigate to home page
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Order placed successfully! Cart cleared. Welcome back to home.',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
