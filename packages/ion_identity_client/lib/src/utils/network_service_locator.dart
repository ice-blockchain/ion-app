import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/utils/auth_interceptor.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkServiceLocator {
  static Dio? _dioInstance;
  static TokenStorage? _tokenStorageInstance;
  static AuthInterceptor? _authInterceptor;

  static Dio getDio({
    required IonClientConfig config,
  }) {
    if (_dioInstance != null) {
      return _dioInstance!;
    }

    final dioOptions = BaseOptions(
      baseUrl: config.origin,
      headers: {
        'X-DFNS-APPID': config.appId,
      },
    );
    final dio = Dio(dioOptions);

    dio.interceptors.addAll(getInterceptors());

    _dioInstance = dio;

    return dio;
  }

  static Iterable<Interceptor> getInterceptors() {
    final interceptors = <Interceptor>[];

    final authInterceptor = getAuthInterceptor();
    interceptors.add(authInterceptor);

    final loggerInterceptor = PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
    );
    interceptors.add(loggerInterceptor);

    return interceptors;
  }

  static AuthInterceptor getAuthInterceptor() {
    if (_authInterceptor != null) {
      return _authInterceptor!;
    }

    final tokenStorage = getTokenStorage();
    _authInterceptor = AuthInterceptor(tokenStorage: tokenStorage);
    return _authInterceptor!;
  }

  static TokenStorage getTokenStorage() {
    if (_tokenStorageInstance != null) {
      return _tokenStorageInstance!;
    }

    _tokenStorageInstance = TokenStorage();
    return _tokenStorageInstance!;
  }
}
