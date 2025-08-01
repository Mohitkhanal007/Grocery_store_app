import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/core/network/api_service.dart';
import 'package:jerseyhub/features/payment/data/model/payment_model.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';

abstract class PaymentRemoteDataSource {
  Future<Either<Failure, PaymentResponseModel>> createPayment(
    PaymentRequestEntity request,
  );

  Future<Either<Failure, PaymentModel>> verifyPayment({
    required String orderId,
    required String amount,
    required String referenceId,
    required String signature,
  });

  Future<Either<Failure, PaymentModel>> getPaymentStatus(String orderId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiService apiService;

  PaymentRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, PaymentResponseModel>> createPayment(
    PaymentRequestEntity request,
  ) async {
    try {
      final response = await apiService.dio.post(
        'esewa/create-payment',
        data: {
          'orderId': request.orderId,
          'amount': request.amount,
          'customerName': request.customerName,
          'customerEmail': request.customerEmail,
          'method': _getMethodString(request.method),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final paymentResponse = PaymentResponseModel.fromJson(response.data);
        return Right(paymentResponse);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to create payment'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> verifyPayment({
    required String orderId,
    required String amount,
    required String referenceId,
    required String signature,
  }) async {
    try {
      final response = await apiService.dio.post(
        'esewa/verify-payment',
        data: {
          'oid': orderId,
          'amt': amount,
          'refId': referenceId,
          'sig': signature,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        // For now, return a mock payment model since backend doesn't return full payment data
        final paymentModel = PaymentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          orderId: orderId,
          amount: double.parse(amount),
          methodString: 'esewa',
          statusString: 'completed',
          transactionId: referenceId,
          referenceId: referenceId,
          createdAt: DateTime.now(),
          completedAt: DateTime.now(),
        );
        return Right(paymentModel);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Payment verification failed'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> getPaymentStatus(String orderId) async {
    try {
      final response = await apiService.dio.get(
        'esewa/payment-status/$orderId',
      );

      if (response.statusCode == 200 && response.data != null) {
        // For now, return a mock payment model since backend doesn't return full payment data
        final paymentModel = PaymentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          orderId: orderId,
          amount: 0.0, // This should come from the actual response
          methodString: 'esewa',
          statusString: response.data['status'] ?? 'pending',
          transactionId: response.data['refId'],
          referenceId: response.data['refId'],
          createdAt: DateTime.now(),
          completedAt: response.data['verifiedAt'] != null
              ? DateTime.parse(response.data['verifiedAt'])
              : null,
        );
        return Right(paymentModel);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to get payment status'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  String _getMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.esewa:
        return 'esewa';
      case PaymentMethod.cashOnDelivery:
        return 'cash_on_delivery';
    }
  }
}
