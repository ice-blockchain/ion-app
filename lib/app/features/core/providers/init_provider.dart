// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/onboarding_complete_provider.dart';
import 'package:ice/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ice/app/features/core/providers/env_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/window_manager_provider.dart';
import 'package:ice/app/services/nostr/nostr.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> initApp(InitAppRef ref) async {
  Nostr.initialize();

  await Future.wait([
    ref.read(windowManagerProvider.notifier).show(),
    ref.read(envProvider.future),
    ref.read(sharedPreferencesProvider.future),
  ]);

  await Future.wait([
    ref.read(appTemplateProvider.future),
    ref.read(authProvider.future),
    ref.read(permissionsProvider.notifier).checkAllPermissions(),
  ]);

  await ref.read(onboardingCompleteProvider.future);
}
