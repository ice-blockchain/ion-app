// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_client_provider.g.dart';

@riverpod
Future<IonApiClient> ionClient(IonClientRef ref) async {
  await dotenv.load(fileName: '.app.env');
  final appId =
      Platform.isAndroid ? dotenv.get('ION_ANDROID_APP_ID') : dotenv.get('ION_IOS_APP_ID');
  final origin = dotenv.get('ION_ORIGIN');

  final config = IonClientConfig(
    appId: appId,
    origin: origin,
  );
  final ionClient = IonApiClient.createDefault(config: config);
  await ionClient.init();

  ref.onDispose(() {
    ionClient.dispose();
  });

  return ionClient;
}
