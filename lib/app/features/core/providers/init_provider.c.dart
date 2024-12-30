// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/core/providers/template_provider.c.dart';
import 'package:ion/app/features/core/providers/window_manager_provider.c.dart';
import 'package:ion/app/services/nostr/nostr.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<void> initApp(Ref ref) async {
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
