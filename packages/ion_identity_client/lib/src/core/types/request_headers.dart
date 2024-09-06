class RequestHeaders {
  static const xDfnsAppId = 'X-DFNS-APPID';
  static const authorization = 'Authorization';

  static Map<String, String> getAuthorizationHeader({
    required String token,
  }) {
    return {
      authorization: 'Bearer $token',
    };
  }
}
