class TokenStorage {
  String? _token;

  String? getToken() {
    return _token;
  }

  // TODO: the implementation gonna be async anyway, so ignore is temporary
  // ignore: use_setters_to_change_properties
  void setToken(String newToken) {
    _token = newToken;
  }

  void clearToken() {
    _token = null;
  }
}
