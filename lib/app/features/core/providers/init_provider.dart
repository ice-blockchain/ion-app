// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/env_provider.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/services/nostr/nostr.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> initApp(InitAppRef ref) async {
  Nostr.initialize();
  await ref.read(envProvider.future);
  await ref.watch(sharedPreferencesProvider.future);
  await Future.wait([
    ref.read(appTemplateProvider.future),
    ref.read(authProvider.notifier).rehydrate(),
  ]);

  ref.watch(relaysProvider.notifier);
  await ref.read(permissionsProvider.notifier).checkAllPermissions();
}
