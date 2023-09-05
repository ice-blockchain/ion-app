import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/env_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.g.dart';

@riverpod
Future<void> initApp(InitAppRef ref) async {
  await ref.read(envProvider.future);
  await ref.read(templateProvider.future);
  await ref.read(authProvider.notifier).rehydrate();
}
