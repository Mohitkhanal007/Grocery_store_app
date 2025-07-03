import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jerseyhub/core/network/hive_service.dart';
import 'package:jerseyhub/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:jerseyhub/features/home/presentation/viewmodel/homepage_viewmodel.dart';
import 'package:jerseyhub/features/splash/presentation/view_model/splash_view_model.dart';
import '../../core/network/api_service.dart';
import '../../features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import '../../features/auth/data/repository/remote_repository/user_remote_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();
  await _initAuthModule();
  await _initApiService();
  await _initSplashModule();
  await _initHomeModule();  // Make sure to call this!
}

Future<void> _initCore() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
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

  serviceLocator.registerLazySingleton<IUserRepository>(
        () => UserRemoteRepository(
      remoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  // Domain layer
  serviceLocator.registerLazySingleton<UserLoginUsecase>(
        () => UserLoginUsecase(userRepository: serviceLocator<IUserRepository>()),
  );

  // Presentation layer
  serviceLocator.registerFactory<LoginViewModel>(
        () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory<HomeViewModel>(() => HomeViewModel());
}
