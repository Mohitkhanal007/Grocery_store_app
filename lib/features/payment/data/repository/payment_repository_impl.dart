import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/payment/data/data_source/payment_remote_datasource.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';
import 'package:jerseyhub/features/payment/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaymentResponseEntity>> createPayment(
    PaymentRequestEntity request,
  ) async {
    final result = await remoteDataSource.createPayment(request);
    return result.fold(
      (failure) => Left(failure),
      (paymentResponse) => Right(paymentResponse.toEntity()),
    );
  }

  @override
  Future<Either<Failure, PaymentEntity>> verifyPayment({
    required String orderId,
    required String amount,
    required String referenceId,
    required String signature,
  }) async {
    final result = await remoteDataSource.verifyPayment(
      orderId: orderId,
      amount: amount,
      referenceId: referenceId,
      signature: signature,
    );
    return result.fold(
      (failure) => Left(failure),
      (payment) => Right(payment.toEntity()),
    );
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(
    String orderId,
  ) async {
    final result = await remoteDataSource.getPaymentStatus(orderId);
    return result.fold(
      (failure) => Left(failure),
      (payment) => Right(payment.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getUserPayments(
    String userId,
  ) async {
    try {
      // This would typically call a backend endpoint
      // For now, return empty list as placeholder
      return const Right([]);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> updatePaymentStatus(
    String paymentId,
    PaymentStatus status,
  ) async {
    try {
      // This would typically call a backend endpoint
      // For now, return a mock payment entity
      final mockPayment = PaymentEntity(
        id: paymentId,
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        amount: 0.0,
        method: PaymentMethod.esewa,
        status: status,
        createdAt: DateTime.now(),
      );
      return Right(mockPayment);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory(
    String userId,
  ) async {
    try {
      // This would typically call a backend endpoint
      // For now, return empty list as placeholder
      return const Right([]);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPaymentAnalytics(
    String userId,
  ) async {
    try {
      // This would typically call a backend endpoint
      // For now, return mock analytics data
      final mockAnalytics = {
        'totalPayments': 0,
        'totalAmount': 0.0,
        'successfulPayments': 0,
        'failedPayments': 0,
        'averageAmount': 0.0,
        'preferredMethod': 'esewa',
      };
      return Right(mockAnalytics);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>>
  getAvailablePaymentMethods() async {
    try {
      // Return available payment methods
      return const Right([PaymentMethod.esewa, PaymentMethod.cashOnDelivery]);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPaymentMethodAvailable(
    PaymentMethod method,
  ) async {
    try {
      // Check if payment method is available
      // For now, all methods are available
      return const Right(true);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
