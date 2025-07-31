import 'package:dartz/dartz.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';
import 'package:jerseyhub/features/product/domain/repository/product_repository.dart';

class GetAllProductsUseCase
    implements UsecaseWithoutParams<List<ProductEntity>> {
  final IProductRepository _repository;

  GetAllProductsUseCase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await _repository.getAllProducts();
  }
}
