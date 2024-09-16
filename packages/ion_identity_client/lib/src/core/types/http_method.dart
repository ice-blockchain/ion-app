enum HttpMethod {
  get,
  post,
  put,
  delete;

  String get value => name.toUpperCase();
}
