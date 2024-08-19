import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/utils/auth_interceptor.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkServiceLocator with _Dio, _Interceptors, _TokenStorage, _NetworkClient {
  factory NetworkServiceLocator() {
    return _instance;
  }

  NetworkServiceLocator._internal();

  static final NetworkServiceLocator _instance = NetworkServiceLocator._internal();
}

mixin _Dio {
  Dio? _dioInstance;

  Dio getDio({
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

    dio.interceptors.addAll(NetworkServiceLocator().getInterceptors());

    _dioInstance = dio;

    return dio;
  }
}

mixin _Interceptors {
  AuthInterceptor? _authInterceptor;

  Iterable<Interceptor> getInterceptors() {
    final interceptors = <Interceptor>[
      getAuthInterceptor(),
      getLoggerInterceptor(),
    ];

    return interceptors;
  }

  Interceptor getAuthInterceptor() {
    if (_authInterceptor != null) {
      return _authInterceptor!;
    }

    final tokenStorage = NetworkServiceLocator().getTokenStorage();
    _authInterceptor = AuthInterceptor(tokenStorage: tokenStorage);
    return _authInterceptor!;
  }

  Interceptor getLoggerInterceptor() {
    return PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
    );
  }
}

mixin _TokenStorage {
  TokenStorage? _tokenStorageInstance;

  TokenStorage getTokenStorage() {
    if (_tokenStorageInstance != null) {
      return _tokenStorageInstance!;
    }

    _tokenStorageInstance = TokenStorage();
    return _tokenStorageInstance!;
  }
}

mixin _NetworkClient {
  NetworkClient? _networkClient;

  NetworkClient getNetworkClient({
    required IonClientConfig config,
  }) {
    if (_networkClient != null) {
      return _networkClient!;
    }

    final dio = NetworkServiceLocator().getDio(config: config);

    _networkClient = NetworkClient(dio: dio);

    return _networkClient!;
  }
}
