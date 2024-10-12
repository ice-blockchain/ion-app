// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network2/network_client2.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
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
        RequestHeaders.ionIdentityClientId: config.appId,
      },
    );
    final dio = Dio(dioOptions);

    dio.interceptors.addAll(NetworkServiceLocator().getInterceptors());

    _dioInstance = dio;

    return dio;
  }
}

mixin _Interceptors {
  Iterable<Interceptor> getInterceptors() {
    final interceptors = <Interceptor>[
      getLoggerInterceptor(),
    ];

    return interceptors;
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
  FlutterSecureStorage? _flutterSecureStorage;

  TokenStorage getTokenStorage() {
    if (_tokenStorageInstance != null) {
      return _tokenStorageInstance!;
    }

    _tokenStorageInstance = TokenStorage(
      secureStorage: getFlutterSecureStorage(),
    );
    return _tokenStorageInstance!;
  }

  FlutterSecureStorage getFlutterSecureStorage() {
    if (_flutterSecureStorage != null) {
      return _flutterSecureStorage!;
    }

    _flutterSecureStorage = const FlutterSecureStorage();
    return _flutterSecureStorage!;
  }
}

mixin _NetworkClient {
  NetworkClient? _networkClient;
  NetworkClient2? _networkClient2;

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

  NetworkClient2 getNetworkClient2({
    required IonClientConfig config,
  }) {
    if (_networkClient2 != null) {
      return _networkClient2!;
    }

    final dio = NetworkServiceLocator().getDio(config: config);

    _networkClient2 = NetworkClient2(dio: dio);

    return _networkClient2!;
  }
}
