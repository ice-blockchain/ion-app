// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:ion/app/services/logger/logger.dart';

String? formattedFileSize(String path) {
  try {
    final file = File(path);

    if (!file.existsSync()) {
      return null;
    }

    return filesize(file.lengthSync());
  } catch (e, stackTrace) {
    Logger.error(e, stackTrace: stackTrace);
    return null;
  }
}
