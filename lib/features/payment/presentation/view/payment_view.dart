import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';
import 'package:jerseyhub/features/payment/presentation/viewmodel/payment_viewmodel.dart';

class PaymentView extends StatefulWidget {
  final String orderId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailure;

  const PaymentView({
    super.key,
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    this.onPaymentSuccess,
    this.onPaymentFailure,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  PaymentMethod _selectedMethod = PaymentMethod.esewa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
            _buildSummaryRow('Amount', '\$${widget.amount.toStringAsFixed(2)}'),
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
              PaymentMethod.esewa,
              'eSewa',
              'Pay securely with eSewa',
              Icons.payment,
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
      case PaymentMethod.esewa:
        return 'Pay with eSewa';
      case PaymentMethod.cashOnDelivery:
        return 'Place Order (Cash on Delivery)';
    }
  }

  void _processPayment() {
    switch (_selectedMethod) {
      case PaymentMethod.esewa:
        _processEsewaPayment();
        break;
      case PaymentMethod.cashOnDelivery:
        _processCashOnDelivery();
        break;
    }
  }

  void _processEsewaPayment() {
    print('💳 Processing eSewa payment...');
    print('📋 Order ID: ${widget.orderId}');
    print('💰 Amount: ${widget.amount}');
    print('👤 Customer: ${widget.customerName}');
    print('📧 Email: ${widget.customerEmail}');

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
    // For cash on delivery, we can directly call the success callback
    widget.onPaymentSuccess?.call();
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
      print('🌐 Attempting to launch URL: $url');
      final uri = Uri.parse(url);

      // Try different launch modes
      bool launched = false;

      // First try: External application mode
      try {
        print('🚀 Trying external application mode...');
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('✅ External application mode result: $launched');
      } catch (e) {
        print('❌ External application mode failed: $e');
      }

      // Second try: In-app browser mode
      if (!launched) {
        try {
          print('🚀 Trying in-app browser mode...');
          launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
          print('✅ In-app browser mode result: $launched');
        } catch (e) {
          print('❌ In-app browser mode failed: $e');
        }
      }

      // Third try: Platform default mode
      if (!launched) {
        try {
          print('🚀 Trying platform default mode...');
          launched = await launchUrl(uri);
          print('✅ Platform default mode result: $launched');
        } catch (e) {
          print('❌ Platform default mode failed: $e');
        }
      }

      if (launched) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment page opened successfully'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else {
        print('❌ All launch methods failed for URL: $url');
        _showUrlDialog(url);
      }
    } catch (e) {
      print('💥 Error launching URL: $e');
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
}
