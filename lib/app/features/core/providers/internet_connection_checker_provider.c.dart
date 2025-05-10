// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_connection_checker_provider.c.g.dart';

const _checkInterval = Duration(seconds: 10);
const _timeoutDuration = Duration(seconds: 10);

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
    checkInterval: _checkInterval,
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
          responseStatusFn: _checkStatus,
        ),
      )
      .toList();
}

bool _checkStatus(http.Response response) => response.statusCode >= 200;
