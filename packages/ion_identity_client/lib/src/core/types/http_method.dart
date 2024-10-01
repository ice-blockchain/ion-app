// SPDX-License-Identifier: ice License 1.0

enum HttpMethod {
  get,
  post,
  put,
  delete;

  String get value => name.toUpperCase();
}
