// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.r.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();

  final logger = Logger.talkerDioLogger;

  if (logger != null) {
    dio.interceptors.add(logger);
  }

  return dio;
}
