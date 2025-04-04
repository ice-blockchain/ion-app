// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_provider.c.g.dart';

@riverpod
Future<IONIdentity> ionIdentity(Ref ref) async {
  final appId = Platform.isAndroid
      ? const String.fromEnvironment('ION_ANDROID_APP_ID')
      : const String.fromEnvironment('ION_IOS_APP_ID');
  final origin = dotenv.get('ION_ORIGIN');

  final config = IONIdentityConfig(
    appId: appId,
    origin: origin,
    logger: LogInterceptor(
      requestHeader: false,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      logPrint: (object) {
        final str = object.toString();
        if (str.length > 1000) {
          for (var i = 0; i < str.length; i += 1000) {
            final end = (i + 1000 < str.length) ? i + 1000 : str.length;
            debugPrint(str.substring(i, end));
          }
        } else {
          debugPrint(str);
        }
      },
    ),
  );
  final ionIdentity = IONIdentity.createDefault(config: config);
  await ionIdentity.init();

  ref.onDispose(() {
    ionIdentity.dispose();
  });

  return ionIdentity;
}
