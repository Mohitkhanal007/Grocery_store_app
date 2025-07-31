import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';
import 'package:jerseyhub/features/product/domain/repository/product_repository.dart';

class GetProductsByCategoryParams extends Equatable {
  final String categoryId;

  const GetProductsByCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class GetProductsByCategoryUseCase
    implements
        UsecaseWithParams<List<ProductEntity>, GetProductsByCategoryParams> {
  final IProductRepository _repository;

  GetProductsByCategoryUseCase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetProductsByCategoryParams params,
  ) async {
    return await _repository.getProductsByCategory(params.categoryId);
  }
}
