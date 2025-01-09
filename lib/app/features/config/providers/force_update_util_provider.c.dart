// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'force_update_util_provider.c.g.dart';

class ForceUpdateUtil {
  const ForceUpdateUtil(this.env);

  final Env env;

  Future<void> handleForceUpdateRedirect() async {
    if (Platform.isAndroid) {
      final androidAppId = env.get<String>(EnvVariable.ION_ANDROID_APP_ID);
      final androidUrl = 'https://play.google.com/store/apps/details?id=$androidAppId';
      await _openUrl(androidUrl);
    } else if (Platform.isIOS) {
      final iosAppId = env.get<String>(EnvVariable.ION_IOS_APP_ID);
      final iosUrl = 'https://apps.apple.com/app/id$iosAppId';
      await _openUrl(iosUrl);
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      const fallbackWebsite = 'https://example.com'; //TODO: Replace with the actual website
      await _openUrl(fallbackWebsite);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw ForceUpdateCouldntLaunchUrlException(url: url);
    }
  }

  bool isVersionOutdated(String localVersion, String remoteVersion) {
    final localParts = localVersion.split('.').map(int.parse).toList();
    final remoteParts = remoteVersion.split('.').map(int.parse).toList();

    for (var i = 0; i < remoteParts.length; i++) {
      if (localParts.length <= i || localParts[i] < remoteParts[i]) {
        return true;
      } else if (localParts[i] > remoteParts[i]) {
        return false;
      }
    }
    return false;
  }
}

@riverpod
ForceUpdateUtil forceUpdateService(Ref ref) {
  return ForceUpdateUtil(ref.watch(envProvider.notifier));
}
