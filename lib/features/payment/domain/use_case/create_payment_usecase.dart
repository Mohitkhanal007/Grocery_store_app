import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';
import 'package:jerseyhub/features/payment/domain/repository/payment_repository.dart';

class CreatePaymentUseCase implements UsecaseWithParams<PaymentResponseEntity, PaymentRequestEntity> {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentResponseEntity>> call(PaymentRequestEntity params) async {
    return await repository.createPayment(params);
  }
} 