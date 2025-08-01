// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_connection_checker_provider.r.g.dart';

const _timeoutDuration = Duration(seconds: 8);

@Riverpod(keepAlive: true)
InternetConnection internetConnectionChecker(Ref ref) {
  const uris = [
    'https://1.1.1.1', // Cloudflare
    'http://8.8.8.8', // Google
    'http://9.9.9.9', // Quad9
    'http://77.88.8.8', // Yandex
    'http://64.6.64.6', // Comodo
  ];

  return InternetConnection.createInstance(
    useDefaultOptions: false,
    customCheckOptions: _createCheckOptions(uris),
  );
}

List<InternetCheckOption> _createCheckOptions(List<String> uris) {
  return uris
      .map(
        (uri) => InternetCheckOption(
          uri: Uri.parse(uri),
          timeout: _timeoutDuration,
          responseStatusFn: (response) => _checkStatus(response.statusCode),
        ),
      )
      .toList();
}

bool _checkStatus(int statusCode) => statusCode >= 200;
