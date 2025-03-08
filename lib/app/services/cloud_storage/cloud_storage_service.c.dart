// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/cloud_storage/google_drive_storage_service.c.dart';
import 'package:ion/app/services/cloud_storage/icloud_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cloud_storage_service.c.g.dart';

@Riverpod(keepAlive: true)
CloudStorageService cloudStorage(Ref ref) {
  final env = ref.watch(envProvider.notifier);
  if (Platform.isAndroid) {
    return GoogleDriveStorageService();
  } else if (Platform.isIOS) {
    return ICloudStorageService(containerId: env.get(EnvVariable.ICLOUD_CONTAINER_ID));
  } else {
    throw UnimplementedError('Current platform is not supported');
  }
}

abstract class CloudStorageService {
  Future<bool> isAvailable();
  Future<List<String>> listFilesPaths({String? directory});
  Future<void> uploadFile(String filePath, String fileContent);
  Future<String?> downloadFile(String filePath);
  Future<void> deleteFile(String filePath);
}
