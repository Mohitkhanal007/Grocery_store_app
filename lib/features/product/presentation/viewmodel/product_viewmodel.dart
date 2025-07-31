import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_all_products_usecase.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_product_by_id_usecase.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_products_by_category_usecase.dart';
import 'package:jerseyhub/features/product/domain/use_case/search_products_usecase.dart';

// Events
abstract class ProductEvent {}

class LoadAllProductsEvent extends ProductEvent {}

class LoadProductsByCategoryEvent extends ProductEvent {
  final String categoryId;
  LoadProductsByCategoryEvent({required this.categoryId});
}

class LoadProductByIdEvent extends ProductEvent {
  final String productId;
  LoadProductByIdEvent({required this.productId});
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  SearchProductsEvent({required this.query});
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductEntity> products;
  ProductsLoaded({required this.products});
}

class ProductLoaded extends ProductState {
  final ProductEntity product;
  ProductLoaded({required this.product});
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  ProductViewModel({
    required GetAllProductsUseCase getAllProductsUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _getAllProductsUseCase = getAllProductsUseCase,
       _getProductByIdUseCase = getProductByIdUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(ProductInitial()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);
    on<LoadProductByIdEvent>(_onLoadProductById);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    print('ProductViewModel: Loading all products...');
    emit(ProductLoading());
    final result = await _getAllProductsUseCase();
    result.fold(
      (failure) {
        print('ProductViewModel: Error loading products: ${failure.message}');
        emit(ProductError(message: failure.message));
      },
      (products) {
        print('ProductViewModel: Loaded ${products.length} products');
        emit(ProductsLoaded(products: products));
      },
    );
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    print(
      'ProductViewModel: Loading products for category: ${event.categoryId}',
    );
    emit(ProductLoading());
    final result = await _getProductsByCategoryUseCase(
      GetProductsByCategoryParams(categoryId: event.categoryId),
    );
    result.fold(
      (failure) {
        print(
          'ProductViewModel: Error loading products by category: ${failure.message}',
        );
        emit(ProductError(message: failure.message));
      },
      (products) {
        print(
          'ProductViewModel: Loaded ${products.length} products for category ${event.categoryId}',
        );
        emit(ProductsLoaded(products: products));
      },
    );
  }

  Future<void> _onLoadProductById(
    LoadProductByIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await _getProductByIdUseCase(
      GetProductByIdParams(id: event.productId),
    );
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (product) => emit(ProductLoaded(product: product)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await _searchProductsUseCase(
      SearchProductsParams(query: event.query),
    );
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }
}
