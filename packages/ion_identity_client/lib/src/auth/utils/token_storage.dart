class TokenStorage {
  String? _token;

  String? getToken() {
    return _token;
  }

  void setToken(String newToken) {
    _token = newToken;
  }

  void clearToken() {
    _token = null;
  }
}
