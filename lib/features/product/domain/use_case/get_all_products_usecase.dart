import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/product/domain/repository/product_repository.dart';

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
