// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/core/providers/template_provider.c.dart';
import 'package:ion/app/features/core/providers/window_manager_provider.c.dart';
import 'package:ion/app/features/user/providers/update_user_metadata_notifier.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coin_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/networks/networks_initializer.c.dart';
import 'package:ion/app/features/wallets/providers/coins_sync_provider.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ion_connect_logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/utils/functions.dart';
import 'package:ion/l10n/timeago_locales.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<void> initApp(Ref ref) async {
  final featureFlagsNotifier = ref.read(featureFlagsProvider.notifier);
  final logIonConnect = featureFlagsNotifier.get(LoggerFeatureFlag.logIonConnect);

  IonConnect.initialize(logIonConnect ? IonConnectLogger() : null);

  await Future.wait([
    ref.read(windowManagerProvider.notifier).show(),
    ref.read(sharedPreferencesProvider.future),
    ref.read(appTemplateProvider.future),
    ref.read(authProvider.future),
    ref.read(permissionsProvider.notifier).checkAllPermissions(),
    ref.read(onboardingCompleteProvider.future),
  ]);

  await [
    ref.read(coinInitializerProvider).initialize(),
    ref.read(networksInitializerProvider).initialize(),
  ].wait;

  // `ref.read` lets `coinsSyncProvider` be disposed even though it's a keepAlive provider
  // so we need to listen to it to keep it alive
  ref
    ..listen(coinsSyncProvider, noop)
    ..listen(connectedCryptoWalletsProvider, (_, __) {
      ref.read(updateUserMetadataNotifierProvider.notifier).updatePublishedWallets();
    });

  registerTimeagoLocalesForEnum();
}
