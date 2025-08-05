import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/product/domain/repository/product_repository.dart';

class GetProductByIdParams extends Equatable {
  final String id;

  const GetProductByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetProductByIdUseCase
    implements UsecaseWithParams<ProductEntity, GetProductByIdParams> {
  final IProductRepository _repository;

  GetProductByIdUseCase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProductEntity>> call(
    GetProductByIdParams params,
  ) async {
    return await _repository.getProductById(params.id);
  }
}
