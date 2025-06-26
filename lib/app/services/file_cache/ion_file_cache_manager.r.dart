// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/file_cache/ion_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_file_cache_manager.r.g.dart';

@Riverpod(keepAlive: true)
CacheManager ionFileCacheManager(Ref ref) => IONCacheManager.instance;

@Riverpod(keepAlive: true)
FileCacheService fileCacheService(Ref ref) =>
    FileCacheService(ref.watch(ionFileCacheManagerProvider));

class FileCacheService {
  FileCacheService(this._cacheManager);

  final CacheManager _cacheManager;

  Future<File> getFile(String url) async {
    return _cacheManager.getSingleFile(url);
  }

  Future<FileInfo?> getFileFromCache(String url) async {
    return _cacheManager.getFileFromCache(url);
  }

  Future<File> putFile({
    required String url,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    return _cacheManager.putFile(url, bytes, fileExtension: fileExtension);
  }

  Future<void> removeFile(String url) async {
    await _cacheManager.removeFile(url);
  }
}
