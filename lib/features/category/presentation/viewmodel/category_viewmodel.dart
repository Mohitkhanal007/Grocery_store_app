import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/features/category/domain/entity/category_entity.dart';
import 'package:grocerystore/features/category/domain/use_case/get_all_categories_usecase.dart';
import 'package:grocerystore/features/category/domain/use_case/get_category_by_id_usecase.dart';

// Events
abstract class CategoryEvent {}

class LoadAllCategoriesEvent extends CategoryEvent {}

class LoadCategoryByIdEvent extends CategoryEvent {
  final String categoryId;
  LoadCategoryByIdEvent({required this.categoryId});
}

// States
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  CategoriesLoaded({required this.categories});
}

class CategoryLoaded extends CategoryState {
  final CategoryEntity category;
  CategoryLoaded({required this.category});
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError({required this.message});
}

class CategoryViewModel extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUseCase _getAllCategoriesUseCase;
  final GetCategoryByIdUseCase _getCategoryByIdUseCase;

  CategoryViewModel({
    required GetAllCategoriesUseCase getAllCategoriesUseCase,
    required GetCategoryByIdUseCase getCategoryByIdUseCase,
  }) : _getAllCategoriesUseCase = getAllCategoriesUseCase,
       _getCategoryByIdUseCase = getCategoryByIdUseCase,
       super(CategoryInitial()) {
    on<LoadAllCategoriesEvent>(_onLoadAllCategories);
    on<LoadCategoryByIdEvent>(_onLoadCategoryById);
  }

  Future<void> _onLoadAllCategories(
    LoadAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    print('CategoryViewModel: Loading all categories...');
    emit(CategoryLoading());
    final result = await _getAllCategoriesUseCase();
    result.fold(
      (failure) {
        print(
          'CategoryViewModel: Error loading categories: ${failure.message}',
        );
        emit(CategoryError(message: failure.message));
      },
      (categories) {
        print('CategoryViewModel: Loaded ${categories.length} categories');
        emit(CategoriesLoaded(categories: categories));
      },
    );
  }

  Future<void> _onLoadCategoryById(
    LoadCategoryByIdEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await _getCategoryByIdUseCase(
      GetCategoryByIdParams(id: event.categoryId),
    );
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (category) => emit(CategoryLoaded(category: category)),
    );
  }
}
