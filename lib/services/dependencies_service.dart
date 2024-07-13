
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import './preferences_service.dart';
import './token_service.dart';
import '../data/repositories/repositories.dart';
import '../blocs/blocs.dart';

class DependenciesService {
  final getIt = GetIt.instance;
  BaseOptions options =  BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
  );
  init() async {
    getIt.registerSingleton(Dio(options));
    getIt.registerSingleton(MirrorsRepository(getIt<Dio>()));
    getIt.registerSingleton(AuthRepository(getIt<Dio>()));
    getIt.registerSingleton(PreferencesService());
    getIt.registerSingleton(TokenService());
    getIt.registerSingleton(AuthBloc());
    getIt.registerSingleton(MirrorsBloc());
  }
}
