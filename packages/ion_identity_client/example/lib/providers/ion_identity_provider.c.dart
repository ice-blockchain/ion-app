// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_provider.c.g.dart';

@riverpod
Future<IONIdentity> ionIdentity(Ref ref) async {
  await dotenv.load(fileName: '.app.env');
  final appId =
      Platform.isAndroid ? dotenv.get('ION_ANDROID_APP_ID') : dotenv.get('ION_IOS_APP_ID');
  final origin = dotenv.get('ION_ORIGIN');

  final config = IONIdentityConfig(
    appId: appId,
    origin: origin,
  );
  final ionIdentity = IONIdentity.createDefault(config: config);
  await ionIdentity.init();

  ref.onDispose(() {
    ionIdentity.dispose();
  });

  return ionIdentity;
}
