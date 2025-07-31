import 'package:dartz/dartz.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/category/domain/entity/category_entity.dart';
import 'package:jerseyhub/features/category/domain/repository/category_repository.dart';

class GetAllCategoriesUseCase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository _repository;

  GetAllCategoriesUseCase({required ICategoryRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await _repository.getAllCategories();
  }
}
