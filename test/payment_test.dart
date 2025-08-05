import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore/features/payment/domain/entity/payment_entity.dart';
import 'package:grocerystore/features/payment/data/model/payment_model.dart';

void main() {
  group('Payment Tests', () {
    test('PaymentRequestEntity should be created correctly', () {
      final request = PaymentRequestEntity(
        orderId: 'ORDER123',
        amount: 99.99,
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        method: PaymentMethod.esewa,
      );

      expect(request.orderId, 'ORDER123');
      expect(request.amount, 99.99);
      expect(request.customerName, 'John Doe');
      expect(request.customerEmail, 'john@example.com');
      expect(request.method, PaymentMethod.esewa);
    });

    test('PaymentResponseEntity should be created correctly', () {
      final response = PaymentResponseEntity(
        success: true,
        paymentUrl: 'https://esewa.com.np/pay',
        transactionId: 'TXN123',
        message: 'Payment created successfully',
      );

      expect(response.success, true);
      expect(response.paymentUrl, 'https://esewa.com.np/pay');
      expect(response.transactionId, 'TXN123');
      expect(response.message, 'Payment created successfully');
    });

    test('PaymentModel should convert from JSON correctly', () {
      final json = {
        'id': 'PAY123',
        'orderId': 'ORDER123',
        'amount': 99.99,
        'method': 'esewa',
        'status': 'pending',
        'transactionId': 'TXN123',
        'customerName': 'John Doe',
        'customerEmail': 'john@example.com',
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final model = PaymentModel.fromJson(json);

      expect(model.id, 'PAY123');
      expect(model.orderId, 'ORDER123');
      expect(model.amount, 99.99);
      expect(model.method, PaymentMethod.esewa);
      expect(model.status, PaymentStatus.pending);
      expect(model.transactionId, 'TXN123');
      expect(model.customerName, 'John Doe');
      expect(model.customerEmail, 'john@example.com');
    });

    test('PaymentRequestModel should convert from JSON correctly', () {
      final json = {
        'orderId': 'ORDER123',
        'amount': 99.99,
        'customerName': 'John Doe',
        'customerEmail': 'john@example.com',
        'method': 'esewa',
      };

      final model = PaymentRequestModel.fromJson(json);

      expect(model.orderId, 'ORDER123');
      expect(model.amount, 99.99);
      expect(model.customerName, 'John Doe');
      expect(model.customerEmail, 'john@example.com');
      expect(model.method, PaymentMethod.esewa);
    });

    test('PaymentResponseModel should convert from JSON correctly', () {
      final json = {
        'success': true,
        'paymentUrl': 'https://esewa.com.np/pay',
        'transactionId': 'TXN123',
        'message': 'Payment created successfully',
      };

      final model = PaymentResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.paymentUrl, 'https://esewa.com.np/pay');
      expect(model.transactionId, 'TXN123');
      expect(model.message, 'Payment created successfully');
    });

    test('PaymentModel should convert to entity correctly', () {
      final model = PaymentModel(
        id: 'PAY123',
        orderId: 'ORDER123',
        amount: 99.99,
        methodString: 'esewa',
        statusString: 'pending',
        transactionId: 'TXN123',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        createdAt: DateTime(2024, 1, 1),
      );

      final entity = model.toEntity();

      expect(entity.id, 'PAY123');
      expect(entity.orderId, 'ORDER123');
      expect(entity.amount, 99.99);
      expect(entity.method, PaymentMethod.esewa);
      expect(entity.status, PaymentStatus.pending);
      expect(entity.transactionId, 'TXN123');
      expect(entity.customerName, 'John Doe');
      expect(entity.customerEmail, 'john@example.com');
    });
  });
}
