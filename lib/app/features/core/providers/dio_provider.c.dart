// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.c.g.dart';

@riverpod
Dio dio(Ref ref) {
  final logApp = ref.read(featureFlagsProvider.notifier).get(LoggerFeatureFlag.logApp);

  final dio = Dio();

  if (logApp) {
    dio.interceptors.add(
      Logger.talkerDioLogger,
    );
  }

  return dio;
}
