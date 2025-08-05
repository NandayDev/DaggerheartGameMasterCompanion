import 'package:flutter_simple_dependency_injection/injector.dart';

class DependencyInjector {
  DependencyInjector._();

  static final _instance = DependencyInjector._();
  final Injector _injector = Injector();

  static DependencyInjector get instance => _instance;

  DependencyInjector registerFactory<T>(T Function() function) {
    _injector.map<T>((i) => function());
    return _instance;
  }

  DependencyInjector registerSingleton<T>(T Function() function) {
    _injector.map<T>((i) => function(), isSingleton: true);
    return _instance;
  }

  static T resolve<T>() => _instance._injector.get<T>();
}
