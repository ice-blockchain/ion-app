// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_connection_checker_provider.c.g.dart';

const _timeoutDuration = Duration(seconds: 8);

@Riverpod(keepAlive: true)
InternetConnection internetConnectionChecker(Ref ref) {
  final env = ref.watch(envProvider.notifier);
  final origin = env.get<String>(EnvVariable.ION_ORIGIN);

  final uris = [
    origin,
    'https://1.1.1.1', // Cloudflare
    'http://8.8.8.8', // Google
    'http://9.9.9.9', // Quad9
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
