import 'dart:io';

import 'package:ice/app/features/core/providers/env_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_client_provider.g.dart';

@Riverpod(keepAlive: true)
IonApiClient ionApiClient(IonApiClientRef ref) {
  final envController = ref.watch(envProvider.notifier);

  final appId = ref.watch(appIdProvider);

  final config = IonClientConfig(
    appId: appId,
    orgId: envController.get(EnvVariable.ION_ORG_ID),
    origin: envController.get(EnvVariable.ION_ORIGIN),
  );

  final ionClient = IonApiClient.createDefault(config: config);

  return ionClient;
}

@Riverpod(keepAlive: true)
String appId(AppIdRef ref) {
  final envController = ref.watch(envProvider.notifier);

  final androidAppId = envController.get(EnvVariable.ION_ANDROID_APP_ID);
  final iosAppId = envController.get(EnvVariable.ION_IOS_APP_ID);

  final appId = Platform.isAndroid ? androidAppId : iosAppId;

  return appId;
}
