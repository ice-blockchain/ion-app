import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_first_run_provider.r.g.dart';

@riverpod
Future<bool> appFirstRun(Ref ref) async {
  final sharedPreferencesFoundation = await ref.read(sharedPreferencesFoundationProvider.future);

  final firstRun = await sharedPreferencesFoundation.getBool('app_first_run') ?? true;
  if (firstRun) {
    await sharedPreferencesFoundation.setBool('app_first_run', false);
  }

  return firstRun;
}
