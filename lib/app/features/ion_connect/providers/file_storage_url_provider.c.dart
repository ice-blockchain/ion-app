// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/utils/file_storage_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_storage_url_provider.c.g.dart';

@riverpod
Future<String> fileStorageUrl(Ref ref) async {
  final cancelToken = CancelToken();

  ref
    ..onDispose(cancelToken.cancel)
    ..cacheFor(const Duration(minutes: 5));

  final url = await getFileStorageApiUrl(ref, cancelToken: cancelToken);
  return url;
}
