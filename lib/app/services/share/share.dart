// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:mime/mime.dart';
import 'package:share_plus/share_plus.dart';

void shareContent(String text, {String? subject}) {
  Share.share(text, subject: subject);
}

void shareFile(String path, {String name = ''}) {
  Share.shareXFiles(
    [
      XFile.fromData(
        File(path).readAsBytesSync(),
        mimeType: lookupMimeType(name),
        name: name,
      ),
    ],
    subject: name,
    fileNameOverrides: [
      name,
    ],
  );
}
