
import 'package:get_it/get_it.dart';
import 'package:jerseyhub/features/splash/data/repository/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void>initDependencies()async{
  await _initHiveService();
  await _initAuthModule();
  await _initSplashModule();
}

Future<void> _initHiveService()async{
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initAuthModule()async{
  serviceLocator.registerLazySingleton(
        () => AuthLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory(
      ()=> LoginViewModle(loginViewModel:serviceLocator<LoginViewModel>()),
  );

}
Future<void> _initSplashModule()async{
  serviceLocator.registerFactory(()=> SplashViewmodel());
}