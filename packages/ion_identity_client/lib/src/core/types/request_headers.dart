class RequestHeaders {
  static const ionIdentityClientId = 'X-Client-ID';
  static const ionIdentityUserAction = 'X-Useraction';
  static const authorization = 'Authorization';

  static Map<String, String> getAuthorizationHeader({
    required String token,
  }) {
    return {
      authorization: 'Bearer $token',
    };
  }
}
