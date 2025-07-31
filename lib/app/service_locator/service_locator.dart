import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jerseyhub/app/shared_prefs/token_shared_prefs.dart';
import 'package:jerseyhub/core/network/hive_service.dart';
import 'package:jerseyhub/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:jerseyhub/features/home/presentation/viewmodel/homepage_viewmodel.dart';
import 'package:jerseyhub/features/product/data/data_source/remote_datasource/product_remote_datasource.dart';
import 'package:jerseyhub/features/product/data/repository/product_repository_impl.dart';
import 'package:jerseyhub/features/product/domain/repository/product_repository.dart';
import 'package:jerseyhub/features/category/data/data_source/remote_datasource/category_remote_datasource.dart';
import 'package:jerseyhub/features/category/data/repository/category_repository_impl.dart';
import 'package:jerseyhub/features/category/domain/repository/category_repository.dart';
import 'package:jerseyhub/features/category/domain/use_case/get_all_categories_usecase.dart';
import 'package:jerseyhub/features/category/domain/use_case/get_category_by_id_usecase.dart';
import 'package:jerseyhub/features/category/presentation/viewmodel/category_viewmodel.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_all_products_usecase.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_product_by_id_usecase.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_products_by_category_usecase.dart';
import 'package:jerseyhub/features/product/domain/use_case/search_products_usecase.dart';
import 'package:jerseyhub/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:jerseyhub/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_service.dart';
import '../../features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import '../../features/auth/data/repository/remote_repository/user_remote_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();
  await _initAuthModule();
  await _initApiService();
  await _initSplashModule();
  await _initHomeModule();
  await _initProductModule(); // Make sure to call this!
  await _initCategoryModule(); // Make sure to call this!
}

Future<void> _initCore() async {
  final hiveService = HiveService();
  await hiveService.init(); // Initialize Hive
  serviceLocator.registerLazySingleton<HiveService>(() => hiveService);

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  // Register TokenSharedPrefs
  serviceLocator.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

Future<void> _initAuthModule() async {
  // Data layer
  serviceLocator.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<IUserRepository>(
    () => UserRemoteRepository(
      remoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  // Domain layer
  serviceLocator.registerLazySingleton<UserLoginUsecase>(
    () => UserLoginUsecase(
      userRepository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );

  serviceLocator.registerLazySingleton<UserRegisterUsecase>(
    () =>
        UserRegisterUsecase(userRepository: serviceLocator<IUserRepository>()),
  );

  serviceLocator.registerLazySingleton<UserLogoutUseCase>(
    () => UserLogoutUseCase(
      repository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // Presentation layer
  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );

  serviceLocator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(logoutUseCase: serviceLocator<UserLogoutUseCase>()),
  );
}

Future<void> _initProductModule() async {
  // Data layer
  serviceLocator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<IProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: serviceLocator<ProductRemoteDataSource>(),
    ),
  );

  // Domain layer
  serviceLocator.registerLazySingleton<GetAllProductsUseCase>(
    () =>
        GetAllProductsUseCase(repository: serviceLocator<IProductRepository>()),
  );

  serviceLocator.registerLazySingleton<GetProductByIdUseCase>(
    () =>
        GetProductByIdUseCase(repository: serviceLocator<IProductRepository>()),
  );

  serviceLocator.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(
      repository: serviceLocator<IProductRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<SearchProductsUseCase>(
    () =>
        SearchProductsUseCase(repository: serviceLocator<IProductRepository>()),
  );

  // Presentation layer
  serviceLocator.registerFactory<ProductViewModel>(
    () => ProductViewModel(
      getAllProductsUseCase: serviceLocator<GetAllProductsUseCase>(),
      getProductByIdUseCase: serviceLocator<GetProductByIdUseCase>(),
      getProductsByCategoryUseCase:
          serviceLocator<GetProductsByCategoryUseCase>(),
      searchProductsUseCase: serviceLocator<SearchProductsUseCase>(),
    ),
  );
}

Future<void> _initCategoryModule() async {
  // Data layer
  serviceLocator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: serviceLocator<CategoryRemoteDataSource>(),
    ),
  );

  // Domain layer
  serviceLocator.registerLazySingleton<GetAllCategoriesUseCase>(
    () => GetAllCategoriesUseCase(
      repository: serviceLocator<ICategoryRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetCategoryByIdUseCase>(
    () => GetCategoryByIdUseCase(
      repository: serviceLocator<ICategoryRepository>(),
    ),
  );

  // Presentation layer
  serviceLocator.registerFactory<CategoryViewModel>(
    () => CategoryViewModel(
      getAllCategoriesUseCase: serviceLocator<GetAllCategoriesUseCase>(),
      getCategoryByIdUseCase: serviceLocator<GetCategoryByIdUseCase>(),
    ),
  );
}
