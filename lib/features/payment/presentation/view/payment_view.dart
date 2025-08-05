import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grocerystore/features/payment/domain/entity/payment_entity.dart';
import 'package:grocerystore/features/payment/presentation/viewmodel/payment_viewmodel.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/app/shared_prefs/user_shared_prefs.dart';
import 'package:grocerystore/features/home/presentation/view/home_page.dart';
import 'package:grocerystore/features/home/presentation/viewmodel/homepage_viewmodel.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:grocerystore/core/theme/theme_manager.dart';
import 'package:grocerystore/features/auth/presentation/view/login_view.dart';
import 'package:grocerystore/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:grocerystore/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:grocerystore/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:grocerystore/features/order/presentation/view/order_list_view.dart';
import 'package:grocerystore/features/profile/presentation/view/profile_view.dart';
import 'package:grocerystore/features/cart/presentation/view/cart_view.dart';
import 'package:grocerystore/features/product/presentation/view/product_list_view.dart';
import 'package:grocerystore/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:grocerystore/app/constant/backend_config.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/order/data/data_source/local_datasource/order_local_datasource.dart';

// Custom HomePage that starts with orders tab selected
class HomePageWithOrdersTab extends StatefulWidget {
  const HomePageWithOrdersTab({super.key});

  @override
  State<HomePageWithOrdersTab> createState() => _HomePageWithOrdersTabState();
}

class _HomePageWithOrdersTabState extends State<HomePageWithOrdersTab> {
  int _selectedIndex = 2; // Start with orders tab (index 2)
  late final CartViewModel _cartViewModel;
  late final ThemeManager _themeManager;

  final List<String> _titles = ['GroceryStore', 'Cart', 'Orders', 'Profile'];

  @override
  void initState() {
    super.initState();
    _cartViewModel = serviceLocator<CartViewModel>();
    _themeManager = ThemeManager();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProfilePage() {
    final userSharedPrefs = serviceLocator<UserSharedPrefs>();
    final userId = userSharedPrefs.getCurrentUserId();

    if (userId == null || userId.isEmpty || userId == 'unknown_user') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Please log in to view your profile',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<LoginViewModel>(),
                      child: const LoginView(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    }

    return BlocProvider(
      create: (context) => serviceLocator<ProfileViewModel>(),
      child: ProfileView(userId: userId),
    );
  }

  Widget _buildProtectedTab(Widget child, String tabName) {
    final userSharedPrefs = serviceLocator<UserSharedPrefs>();
    final userId = userSharedPrefs.getCurrentUserId();

    if (userId == null || userId.isEmpty || userId == 'unknown_user') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tabName == 'Orders' ? Icons.shopping_bag : Icons.notifications,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Please log in to view your $tabName',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<LoginViewModel>(),
                      child: const LoginView(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    final notificationBloc = serviceLocator<NotificationBloc>();

    final List<Widget> pages = [
      BlocProvider(
        create: (context) => serviceLocator<ProductViewModel>(),
        child: ProductListView(
          onNavigateToCart: () {
            setState(() {
              _selectedIndex = 1; // Switch to cart tab
            });
          },
        ),
      ),
      BlocProvider.value(
        value: _cartViewModel,
        child: CartView(
          onShopNowPressed: () {
            setState(() {
              _selectedIndex = 0; // Switch to home/products tab
            });
          },
        ),
      ),
      BlocProvider(
        create: (context) => serviceLocator<OrderViewModel>(),
        child: OrderListView(
          onShopNowPressed: () {
            setState(() {
              _selectedIndex = 0; // Switch to home/products tab
            });
          },
        ),
      ),
      _buildProfilePage(),
    ];

    return BlocProvider.value(
      value: notificationBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            ListenableBuilder(
              listenable: _themeManager,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    _themeManager.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
        body: pages[_selectedIndex],
        floatingActionButton: null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Store',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentView extends StatefulWidget {
  final String orderId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final List<CartItemEntity> cartItems; // Add cart items parameter
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailure;

  const PaymentView({
    super.key,
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.cartItems, // Add cart items parameter
    this.onPaymentSuccess,
    this.onPaymentFailure,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  PaymentMethod? _selectedMethod;

  @override
  void initState() {
    super.initState();
    print(
      '🔍 PaymentView: Initialized with ${widget.cartItems.length} cart items',
    );
    print(
      '🔍 PaymentView: Cart items received: ${widget.cartItems.map((item) => '${item.product.team} - ${item.quantity}').join(', ')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If user presses back button, return false to indicate payment was not completed
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          actions: [
            // Debug button to check user ID
            IconButton(
              onPressed: () {
                final userSharedPrefs = serviceLocator<UserSharedPrefs>();
                final userId = userSharedPrefs.getCurrentUserId();
                final userEmail = userSharedPrefs.getCurrentUserEmail();
                print('🔍 DEBUG: Current User ID: $userId');
                print('🔍 DEBUG: Current User Email: $userEmail');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User ID: $userId\nEmail: $userEmail'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.bug_report),
            ),
            // Debug button to create test order
            IconButton(
              onPressed: () async {
                final userSharedPrefs = serviceLocator<UserSharedPrefs>();
                final userId = userSharedPrefs.getCurrentUserId();

                if (userId == null || userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No user ID found. Please login first.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Create a test order
                final orderId = DateTime.now().millisecondsSinceEpoch
                    .toString();
                final now = DateTime.now();

                // Create a mock product
                final mockProduct = ProductEntity(
                  id: 'test_product_1',
                  team: 'Test Team',
                  type: 'Test Type',
                  size: 'M',
                  price: 29.99,
                  quantity: 10,
                  categoryId: 'test_category',
                  sellerId: 'test_seller',
                  productImage: 'test_image.jpg',
                  createdAt: now,
                  updatedAt: now,
                );

                // Create a mock cart item
                final mockCartItem = CartItemEntity(
                  id: 'test_cart_item_1',
                  product: mockProduct,
                  quantity: 2,
                  selectedSize: 'M',
                  addedAt: now,
                );

                final testOrder = OrderEntity(
                  id: orderId,
                  userId: userId,
                  items: [mockCartItem],
                  subtotal: 59.98,
                  shippingCost: 0.0,
                  totalAmount: 59.98,
                  status: OrderStatus.confirmed,
                  customerName: 'Test Customer',
                  customerEmail: 'test@example.com',
                  customerPhone: '123-456-7890',
                  shippingAddress: 'Test Address',
                  createdAt: now,
                  updatedAt: now,
                );

                print('🔍 DEBUG: Creating test order with ID: $orderId');
                print('🔍 DEBUG: Test order user ID: $userId');

                final orderViewModel = serviceLocator<OrderViewModel>();
                orderViewModel.add(CreateOrderEvent(order: testOrder));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Test order created! ID: $orderId'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
          ],
        ),
        body: BlocListener<PaymentViewModel, PaymentState>(
          listener: (context, state) {
            if (state is PaymentCreated) {
              _handlePaymentCreated(state.response);
            } else if (state is PaymentError) {
              _showErrorSnackBar(state.message);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                const SizedBox(height: 24),
                _buildPaymentMethods(),
                const SizedBox(height: 24),
                _buildPaymentButton(),
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
              'Payment Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Order ID', widget.orderId),
            _buildSummaryRow('Amount', 'रू${widget.amount.toStringAsFixed(2)}'),
            _buildSummaryRow('Customer', widget.customerName),
            _buildSummaryRow('Email', widget.customerEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile(
              PaymentMethod.creditCard,
              'Credit Card',
              'Pay securely with your credit or debit card',
              Icons.credit_card,
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodTile(
              PaymentMethod.cashOnDelivery,
              'Cash on Delivery',
              'Pay when you receive your order',
              Icons.money,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    PaymentMethod method,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return BlocBuilder<PaymentViewModel, PaymentState>(
      builder: (context, state) {
        final isLoading = state is PaymentLoading;

        // Only show button if a payment method is selected
        if (_selectedMethod == null) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _getPaymentButtonText(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  String _getPaymentButtonText() {
    switch (_selectedMethod) {
      case PaymentMethod.creditCard:
        return 'Pay with Credit Card';
      case PaymentMethod.cashOnDelivery:
        return 'Place Order (Cash on Delivery)';
      case PaymentMethod.esewa:
        return 'Pay';
      case null:
        return 'Select Payment Method';
    }
  }

  void _processPayment() {
    switch (_selectedMethod) {
      case PaymentMethod.creditCard:
        _processCreditCardPayment();
        break;
      case PaymentMethod.cashOnDelivery:
        _processCashOnDelivery();
        break;
      case PaymentMethod.esewa:
        _processEsewaPayment();
        break;
      case null:
        // Do nothing if no payment method is selected
        break;
    }
  }

  void _processCreditCardPayment() {
    print('💳 Processing Credit Card payment...');
    print('📋 Order ID: ${widget.orderId}');
    print('💰 Amount: \$${widget.amount.toStringAsFixed(2)}');
    print('👤 Customer: ${widget.customerName}');
    print('📧 Email: ${widget.customerEmail}');

    // Show credit card form
    _showCreditCardForm();
  }

  void _showCreditCardForm() {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Credit Card Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 19,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: expiryController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry (MM/YY)',
                          hintText: '12/25',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Cardholder Name',
                    hintText: 'John Doe',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form
                if (cardNumberController.text.isEmpty ||
                    expiryController.text.isEmpty ||
                    cvvController.text.isEmpty ||
                    nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _processCreditCardPaymentWithCredentials(
                  cardNumberController.text,
                  expiryController.text,
                  cvvController.text,
                  nameController.text,
                );
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  void _processCreditCardPaymentWithCredentials(
    String cardNumber,
    String expiry,
    String cvv,
    String cardholderName,
  ) {
    print('💳 Processing Credit Card payment with credentials...');
    print('📋 Order ID: ${widget.orderId}');
    print('💰 Amount: \$${widget.amount.toStringAsFixed(2)}');
    print('👤 Customer: ${widget.customerName}');
    print('📧 Email: ${widget.customerEmail}');
    print(
      '💳 Card: ${cardNumber.substring(0, 4)}****${cardNumber.substring(cardNumber.length - 4)}',
    );

    // Show processing message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Processing credit card payment...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      _createOrderAndNavigate();
    });
  }

  void _processEsewaPayment() {
    print('💳 Processing eSewa payment...');
    print('📋 Order ID: ${widget.orderId}');
    print('💰 Amount: रू${widget.amount.toStringAsFixed(2)}');
    print('👤 Customer: ${widget.customerName}');
    print('📧 Email: ${widget.customerEmail}');

    // Show processing message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Initializing eSewa payment...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );

    final request = PaymentRequestEntity(
      orderId: widget.orderId,
      amount: widget.amount,
      customerName: widget.customerName,
      customerEmail: widget.customerEmail,
      method: PaymentMethod.esewa,
    );

    print('🚀 Dispatching CreatePaymentEvent...');
    context.read<PaymentViewModel>().add(CreatePaymentEvent(request: request));
  }

  void _processCashOnDelivery() {
    // Show confirmation dialog for cash on delivery
    _showCashOnDeliveryConfirmation();
  }

  void _showCashOnDeliveryConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.money, color: Colors.orange, size: 32),
                    const SizedBox(width: 12),
                    const Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Order Amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Order Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'रू${widget.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Important Information
                const Text(
                  'Important Information:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('• Pay when you receive your order'),
                _buildInfoRow('• Keep exact change ready'),
                _buildInfoRow('• Delivery within 3-5 business days'),
                _buildInfoRow('• Free delivery on orders above रू1000'),
                const SizedBox(height: 20),

                // Warning Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please ensure you have the exact amount ready when the delivery person arrives.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _confirmCashOnDelivery();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Confirm Order',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _confirmCashOnDelivery() {
    // Show processing message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Processing your order...'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );

    // Simulate order processing
    Future.delayed(const Duration(seconds: 2), () {
      _showCashOnDeliverySuccessDialog();
    });
  }

  void _showCashOnDeliverySuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 24),

                // Success Title
                const Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Order Amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Order Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'रू${widget.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order ID
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Order ID: ${widget.orderId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Important Message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You will receive a confirmation call within 24 hours. Please keep रू${widget.amount.toStringAsFixed(2)} ready for delivery.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // OK Button - Navigate to Home Page
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Close dialog
                      _createOrderAndNavigateToOrders();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Go to Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearCartAndNavigateToHome() {
    // Clear the cart
    final userSharedPrefs = serviceLocator<UserSharedPrefs>();
    final userId = userSharedPrefs.getCurrentUserId();
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

  void _handlePaymentCreated(PaymentResponseEntity response) {
    if (response.success && response.paymentUrl != null) {
      _launchPaymentUrl(response.paymentUrl!);
    } else {
      _showErrorSnackBar(response.error ?? 'Payment creation failed');
    }
  }

  Future<void> _launchPaymentUrl(String url) async {
    try {
      print('🌐 Processing eSewa payment...');

      // Check if it's an eSewa URL
      final isEsewaUrl = url.contains('esewa.com.np') || url.contains('esewa');

      if (isEsewaUrl) {
        // Show processing message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Processing eSewa payment...'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );

        // Simulate payment processing
        await Future.delayed(const Duration(seconds: 3));

        // Show success dialog
        _showPaymentSuccessDialog();
      } else {
        // For non-eSewa payments, try to launch the URL
        final uri = Uri.parse(url);
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment page opened successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          _showUrlDialog(url);
        }
      }
    } catch (e) {
      print('💥 Error processing payment: $e');
      _showUrlDialog(url);
    }
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

  void _showUrlDialog(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment URL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please copy this URL and open it in your browser to complete the payment:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  url,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Clipboard.setData(ClipboardData(text: url));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment URL copied to clipboard'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  _showErrorSnackBar('Failed to copy URL: $e');
                }
              },
              child: const Text('Copy URL'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your payment of रू${widget.amount.toStringAsFixed(2)} has been processed successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ID: ${widget.orderId}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Text(
                  'Your order will be processed and you will receive a confirmation shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close dialog and create order
                Navigator.of(context).pop(); // Close dialog

                // Create order and navigate to Orders tab
                _createOrderAndNavigateToOrders();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Go to Orders'),
            ),
          ],
        );
      },
    );
  }

  void _createOrderAndNavigate() {
    // Create order and navigate to orders tab
    _createOrderAndNavigateToOrders();
  }

  void _createOrderAndNavigateToOrders() async {
    try {
      // Get user ID
      final userSharedPrefs = serviceLocator<UserSharedPrefs>();
      final userId = userSharedPrefs.getCurrentUserId();

      print('🔍 PaymentView: Current user ID from SharedPrefs: $userId');

      if (userId == null || userId.isEmpty) {
        print('❌ No user ID found for order creation');
        _showErrorSnackBar('User not logged in. Please login again.');
        _navigateToHomeDirectly();
        return;
      }

      // Use cart items from widget instead of trying to preserve them
      if (widget.cartItems.isEmpty) {
        print('❌ PaymentView: No cart items provided for order creation');
        print(
          '❌ PaymentView: widget.cartItems.length = ${widget.cartItems.length}',
        );
        _showErrorSnackBar(
          'No items in cart. Please add items before checkout.',
        );
        _navigateToHomeDirectly();
        return;
      }

      print(
        '🔍 PaymentView: Using ${widget.cartItems.length} cart items from widget',
      );
      print(
        '🔍 PaymentView: Cart items: ${widget.cartItems.map((item) => '${item.product.team} - ${item.quantity}').join(', ')}',
      );

      // Create OrderEntity from cart items
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      final order = OrderEntity(
        id: orderId,
        userId: userId,
        items: widget.cartItems, // Use cart items from widget
        subtotal: widget.cartItems.fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        ),
        shippingCost: 0.0, // Free shipping for now
        totalAmount: widget.cartItems.fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        ),
        status: OrderStatus.confirmed,
        customerName: widget.customerName,
        customerEmail: widget.customerEmail,
        customerPhone: 'N/A',
        shippingAddress: 'Payment completed - Address to be updated',
        createdAt: now,
        updatedAt: now,
      );

      print('🔗 PaymentView: Creating order with ID: $orderId');
      print(
        '🔗 PaymentView: Order details - UserID: ${order.userId}, Total: ${order.totalAmount}, Items: ${order.items.length}',
      );

      // Create order using local mechanism
      final orderViewModel = serviceLocator<OrderViewModel>();
      orderViewModel.add(CreateOrderEvent(order: order));

      // Wait a bit for the order to be created
      await Future.delayed(const Duration(milliseconds: 1000));

      // Verify the order was created by checking local storage
      final localDataSource = serviceLocator<OrderLocalDataSource>();
      final savedOrders = await localDataSource.getAllOrders(userId);
      print(
        '🔍 PaymentView: Found ${savedOrders.length} orders in local storage after creation',
      );

      final createdOrder = savedOrders.firstWhere(
        (o) => o.id == orderId,
        orElse: () => throw Exception('Order not found in local storage'),
      );
      print(
        '✅ PaymentView: Order successfully saved to local storage - ID: ${createdOrder.id}',
      );

      // Clear cart after successful order creation
      final cartViewModel = serviceLocator<CartViewModel>();
      cartViewModel.add(ClearCartEvent(userId: userId));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Order created successfully! Order ID: ${order.id.substring(0, 8)}...',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to home and switch to orders tab
      _navigateToHomeAndSwitchToOrders();
    } catch (e) {
      print('💥 PaymentView: Error creating order: $e');
      _showErrorSnackBar('Error creating order: $e');
      _navigateToHomeDirectly();
    }
  }

  void _navigateToHomeAndSwitchToOrders() {
    // Navigate to home page and switch to orders tab
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<HomeViewModel>(),
          child: const HomePageWithOrdersTab(),
        ),
      ),
      (route) => false, // Remove all routes
    );

    // Show message to check orders tab
    Future.delayed(const Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Order placed successfully! Check your Orders tab.',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  void _navigateToHomeDirectly() {
    // Navigate to home page without switching to orders tab
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<HomeViewModel>(),
          child: const HomePage(),
        ),
      ),
      (route) => false, // Remove all routes
    );
  }
}
