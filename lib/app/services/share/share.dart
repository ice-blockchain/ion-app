// SPDX-License-Identifier: ice License 1.0

import 'package:share_plus/share_plus.dart';

void shareContent(String text, {String subject = ''}) {
  Share.share(text, subject: subject);
}
