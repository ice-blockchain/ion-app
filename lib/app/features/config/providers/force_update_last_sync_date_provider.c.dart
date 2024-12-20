// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'force_update_last_sync_date_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ForceUpdateLastSyncDateNotifier extends _$ForceUpdateLastSyncDateNotifier {
  static const String forceUpdateLastSyncDateKey = 'forceUpdateLastSyncDateKey';

  @override
  DateTime? build() {
    final storedDate = ref.watch(localStorageProvider).getString(forceUpdateLastSyncDateKey);
    if (storedDate != null) {
      return DateTime.parse(storedDate);
    }
    return null;
  }

  void updateLastSyncDate(DateTime date) {
    state = date;
    ref.read(localStorageProvider).setString(forceUpdateLastSyncDateKey, date.toIso8601String());
  }
}
