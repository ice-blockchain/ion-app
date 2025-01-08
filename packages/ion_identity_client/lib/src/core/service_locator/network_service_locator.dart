// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/auth_interceptor.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/auth_client_service_locator.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';

class NetworkServiceLocator
    with _Dio, _Interceptors, _TokenStorage, _PrivateKeyStorage, _NetworkClient {
  factory NetworkServiceLocator() {
    return _instance;
  }

  NetworkServiceLocator._internal();

  static final NetworkServiceLocator _instance = NetworkServiceLocator._internal();
}

mixin _Dio {
  Dio? _dioInstance;

  Dio dio({
    required IONIdentityConfig config,
  }) {
    if (_dioInstance != null) {
      return _dioInstance!;
    }

    _dioInstance = _defaultDio(config);

    final interceptors = NetworkServiceLocator().interceptors(config: config).toList();
    _dioInstance!.interceptors.addAll(interceptors);

    return _dioInstance!;
  }

  Dio _defaultDio(IONIdentityConfig config) {
    final dioOptions = BaseOptions(
      baseUrl: config.origin,
      headers: {
        RequestHeaders.ionIdentityClientId: config.appId,
      },
    );
    final dio = Dio(dioOptions);

    return dio;
  }

  Dio _refreshTokenDio(
    IONIdentityConfig config,
  ) {
    final dioOptions = BaseOptions(
      baseUrl: config.origin,
      headers: {
        RequestHeaders.ionIdentityClientId: config.appId,
      },
    );
    final dio = Dio(dioOptions);

    final interceptors = [
      if (config.logger != null) config.logger!,
    ];
    dio.interceptors.addAll(interceptors);

    return dio;
  }
}

mixin _Interceptors {
  final StringBuffer _logBuffer = StringBuffer();
  String get logs => _logBuffer.toString();

  Iterable<Interceptor> interceptors({
    required IONIdentityConfig config,
  }) {
    final logger = config.logger;
    return <Interceptor>[
      if (config.logger != null) logger!,
      authInterceptor(config: config),
    ];
  }

  AuthInterceptor authInterceptor({
    required IONIdentityConfig config,
  }) {
    return AuthInterceptor(
      dio: NetworkServiceLocator()._refreshTokenDio(config),
      delegatedLoginService: AuthClientServiceLocator().delegatedLogin(config: config),
    );
  }
}

mixin _TokenStorage {
  TokenStorage? _tokenStorageInstance;
  FlutterSecureStorage? _flutterSecureStorage;

  TokenStorage tokenStorage() {
    if (_tokenStorageInstance != null) {
      return _tokenStorageInstance!;
    }

    _tokenStorageInstance = TokenStorage(
      secureStorage: flutterSecureStorage(),
    );
    return _tokenStorageInstance!;
  }

  FlutterSecureStorage flutterSecureStorage() {
    if (_flutterSecureStorage != null) {
      return _flutterSecureStorage!;
    }

    _flutterSecureStorage = const FlutterSecureStorage();
    return _flutterSecureStorage!;
  }
}

mixin _PrivateKeyStorage {
  PrivateKeyStorage? _privateKeyStorageInstance;
  FlutterSecureStorage? _flutterSecureStorage;

  PrivateKeyStorage privateKeyStorage() {
    if (_privateKeyStorageInstance != null) {
      return _privateKeyStorageInstance!;
    }

    _privateKeyStorageInstance = PrivateKeyStorage(
      secureStorage: flutterSecureStorage(),
    );
    return _privateKeyStorageInstance!;
  }

  FlutterSecureStorage flutterSecureStorage() {
    if (_flutterSecureStorage != null) {
      return _flutterSecureStorage!;
    }

    _flutterSecureStorage = const FlutterSecureStorage();
    return _flutterSecureStorage!;
  }
}

mixin _NetworkClient {
  NetworkClient? _networkClient;

  NetworkClient networkClient({
    required IONIdentityConfig config,
  }) {
    if (_networkClient != null) {
      return _networkClient!;
    }

    final dio = NetworkServiceLocator().dio(config: config);

    _networkClient = NetworkClient(dio: dio);

    return _networkClient!;
  }
}
