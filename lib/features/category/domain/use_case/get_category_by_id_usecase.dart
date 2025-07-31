import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/category/domain/entity/category_entity.dart';
import 'package:jerseyhub/features/category/domain/repository/category_repository.dart';

class GetCategoryByIdParams extends Equatable {
  final String id;

  const GetCategoryByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetCategoryByIdUseCase
    implements UsecaseWithParams<CategoryEntity, GetCategoryByIdParams> {
  final ICategoryRepository _repository;

  GetCategoryByIdUseCase({required ICategoryRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CategoryEntity>> call(
    GetCategoryByIdParams params,
  ) async {
    return await _repository.getCategoryById(params.id);
  }
}
