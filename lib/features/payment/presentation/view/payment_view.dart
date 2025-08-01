import 'package:flutter/material.dart';
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
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
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
            const SizedBox(height: 8),
            _buildPaymentMethodTile(
              PaymentMethod.bankTransfer,
              'Bank Transfer',
              'Transfer to our bank account',
              Icons.account_balance,
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
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
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
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      case PaymentMethod.bankTransfer:
        return 'Get Bank Details';
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
      case PaymentMethod.bankTransfer:
        _showBankDetails();
        break;
    }
  }

  void _processEsewaPayment() {
    final request = PaymentRequestEntity(
      orderId: widget.orderId,
      amount: widget.amount,
      customerName: widget.customerName,
      customerEmail: widget.customerEmail,
      method: PaymentMethod.esewa,
    );

    context.read<PaymentViewModel>().add(CreatePaymentEvent(request: request));
  }

  void _processCashOnDelivery() {
    // For cash on delivery, we can directly call the success callback
    widget.onPaymentSuccess?.call();
  }

  void _showBankDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bank Transfer Details'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bank: Example Bank'),
              Text('Account Number: 1234567890'),
              Text('Account Holder: JerseyHub'),
              Text('Branch: Main Branch'),
              SizedBox(height: 16),
              Text(
                'Please include your Order ID in the transfer description.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
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
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch payment page');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching payment page: $e');
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
} 