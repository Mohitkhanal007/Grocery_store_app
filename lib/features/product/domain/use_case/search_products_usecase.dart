import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/product/domain/repository/product_repository.dart';

class SearchProductsParams extends Equatable {
  final String query;

  const SearchProductsParams({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchProductsUseCase
    implements UsecaseWithParams<List<ProductEntity>, SearchProductsParams> {
  final IProductRepository _repository;

  SearchProductsUseCase({required IProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    SearchProductsParams params,
  ) async {
    return await _repository.searchProducts(params.query);
  }
}
