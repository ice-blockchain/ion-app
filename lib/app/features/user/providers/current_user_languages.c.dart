// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_languages.c.g.dart';

@riverpod
class CurrentUserLanguages extends _$CurrentUserLanguages {
  @override
  FutureOr<void> build() {}

  Future<void> set(List<String> languages) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final data = InterestSetData(type: InterestSetType.languages, hashtags: languages);
      await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(data);
    });
  }
}
