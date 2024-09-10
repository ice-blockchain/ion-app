class RequestHeaders {
  static const ionIdentityClientId = 'X-Client-ID';
  static const authorization = 'Authorization';

  static Map<String, String> getAuthorizationHeader({
    required String token,
  }) {
    return {
      authorization: 'Bearer $token',
    };
  }
}
