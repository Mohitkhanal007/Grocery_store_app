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
}
