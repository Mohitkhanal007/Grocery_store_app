import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';

abstract class PaymentRepository {
  // Payment creation and processing
  Future<Either<Failure, PaymentResponseEntity>> createPayment(
    PaymentRequestEntity request,
  );

  // Payment verification
  Future<Either<Failure, PaymentEntity>> verifyPayment({
    required String orderId,
    required String amount,
    required String referenceId,
    required String signature,
  });

  // Payment status management
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String orderId);
  Future<Either<Failure, List<PaymentEntity>>> getUserPayments(String userId);
  Future<Either<Failure, PaymentEntity>> updatePaymentStatus(
    String paymentId,
    PaymentStatus status,
  );

  // Payment history and analytics
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory(String userId);
  Future<Either<Failure, Map<String, dynamic>>> getPaymentAnalytics(
    String userId,
  );

  // Payment methods management
  Future<Either<Failure, List<PaymentMethod>>> getAvailablePaymentMethods();
  Future<Either<Failure, bool>> isPaymentMethodAvailable(PaymentMethod method);
}
