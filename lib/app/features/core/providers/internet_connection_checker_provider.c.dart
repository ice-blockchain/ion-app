// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_connection_checker_provider.c.g.dart';

const _checkInterval = Duration(seconds: 8);
const _timeoutDuration = Duration(seconds: 5);

@Riverpod(keepAlive: true)
InternetConnection internetConnectionChecker(Ref ref) {
  final env = ref.watch(envProvider.notifier);
  final origin = env.get<String>(EnvVariable.ION_ORIGIN);

  return InternetConnection.createInstance(
    checkInterval: _checkInterval,
    useDefaultOptions: false,
    customCheckOptions: [
      InternetCheckOption(
        uri: Uri.parse(origin),
        timeout: _timeoutDuration,
        responseStatusFn: (response) => response.statusCode >= 200,
      ),
    ],
  );
}
