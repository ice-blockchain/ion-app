// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_provider.g.dart';

enum EnvVariable {
  ION_ANDROID_APP_ID,
  ION_IOS_APP_ID,
  ION_ORIGIN,
  SHOW_DEBUG_INFO,
}

@Riverpod(keepAlive: true)
class Env extends _$Env {
  @override
  Future<void> build() async {
    await dotenv.load(fileName: Assets.aApp);
    final notDefined = _getNotDefined();
    if (notDefined.isNotEmpty) {
      throw Exception('Invalid ENV value for $notDefined');
    }
  }

  List<EnvVariable> _getNotDefined() {
    return EnvVariable.values
        .where((EnvVariable element) => dotenv.maybeGet(element.name) == null)
        .toList();
  }

  T get<T>(EnvVariable variable) {
    final value = dotenv.get(variable.name);

    if (T == bool) {
      return (value.toLowerCase() == 'true') as T;
    }

    return value as T;
  }
}
