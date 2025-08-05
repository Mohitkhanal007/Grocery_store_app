import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/payment/domain/entity/payment_entity.dart';
import 'package:grocerystore/features/payment/domain/repository/payment_repository.dart';

class CreatePaymentUseCase
    implements UsecaseWithParams<PaymentResponseEntity, PaymentRequestEntity> {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentResponseEntity>> call(
    PaymentRequestEntity params,
  ) async {
    return await repository.createPayment(params);
  }
}
