// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<Raw<IONIdentity>> ionIdentity(Ref ref) async {
  final env = ref.read(envProvider.notifier);

  final appId = env.get<String>(
    Platform.isAndroid ? EnvVariable.ION_ANDROID_APP_ID : EnvVariable.ION_IOS_APP_ID,
  );

  final logIonIdentityClient =
      ref.watch(featureFlagsProvider.notifier).get(LoggerFeatureFlag.logIonIdentityClient);

  final config = IONIdentityConfig(
    appId: appId,
    origin: env.get(EnvVariable.ION_ORIGIN),
    logger: logIonIdentityClient
        ? IonIdentityLogger(
            fileOutput: File(
              '${(await getTemporaryDirectory()).path}/${IonIdentityLogger.logFileName}',
            ),
          )
        : null,
  );

  final ionClient = IONIdentity.createDefault(config: config);
  await ionClient.init();

  ref.onDispose(ionClient.dispose);

  return ionClient;
}
