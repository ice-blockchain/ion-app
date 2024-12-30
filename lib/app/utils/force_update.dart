// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateUtil {
  ForceUpdateUtil._();

  static Future<void> handleForceUpdateRedirect() async {
    if (Platform.isAndroid) {
      const appId = EnvVariable.ION_ANDROID_APP_ID;
      final androidUrl = 'https://play.google.com/store/apps/details?id=$appId';
      await _openUrl(androidUrl);
    } else if (Platform.isIOS) {
      const appId = EnvVariable.ION_IOS_APP_ID;
      final iosUrl = 'https://apps.apple.com/app/id$appId';
      await _openUrl(iosUrl);
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await _openWebsite();
    }
  }

  static Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw ForceUpdateCouldntLaunchUrlException(url: url);
    }
  }

  static Future<void> _openWebsite() async {
    const fallbackWebsite = 'https://example.com'; //TODO: Replace with the actual website
    await _openUrl(fallbackWebsite);
  }
}
