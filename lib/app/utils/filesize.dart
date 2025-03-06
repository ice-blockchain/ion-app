// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:filesize/filesize.dart';

String formattedFileSize(String path) {
  return filesize(File(path).lengthSync());
}
