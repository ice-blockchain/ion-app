import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  static const authorizationHeader = 'Authorization';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _tokenStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers[authorizationHeader] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
