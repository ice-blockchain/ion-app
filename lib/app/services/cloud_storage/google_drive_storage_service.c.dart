// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/cloud_storage/cloud_storage_service.c.dart';

final class GoogleDriveStorageService extends CloudStorageService {
  @override
  Future<List<String>> listFilesPaths() {
    // TODO: implement listFilesPaths
    throw UnimplementedError();
  }

  @override
  Future<void> uploadFile(String filePath, String fileContent) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  @override
  Future<String> downloadFile(String filePath) {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }
}
