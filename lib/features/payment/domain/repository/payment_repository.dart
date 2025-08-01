import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentResponseEntity>> createPayment(
    PaymentRequestEntity request,
  );
  
  Future<Either<Failure, PaymentEntity>> verifyPayment({
    required String orderId,
    required String amount,
    required String referenceId,
    required String signature,
  });
  
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String orderId);
} 