// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Raw<IONIdentity>> ionIdentity(Ref ref) async {
  await ref.watch(envProvider.future);
  final envController = ref.watch(envProvider.notifier);

  final appId = envController.get<String>(
    Platform.isAndroid ? EnvVariable.ION_ANDROID_APP_ID : EnvVariable.ION_IOS_APP_ID,
  );

  final config = IONIdentityConfig(
    appId: appId,
    origin: envController.get(EnvVariable.ION_ORIGIN),
  );

  final ionClient = IONIdentity.createDefault(config: config);
  await ionClient.init();

  ref.onDispose(ionClient.dispose);

  return ionClient;
}
