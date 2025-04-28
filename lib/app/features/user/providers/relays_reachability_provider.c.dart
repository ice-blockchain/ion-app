// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_reachability_provider.c.g.dart';

final class RelayReachabilityInfo {
  const RelayReachabilityInfo({
    required this.relayUrl,
    required this.failedToReachCount,
    required this.lastFailedToReachDate,
  });

  final String relayUrl;
  final int failedToReachCount;
  final DateTime lastFailedToReachDate;
}

@riverpod
class RelayReachability extends _$RelayReachability {
  @override
  FutureOr<void> build() async {}

  RelayReachabilityInfo? get(String relayUrl) {
    final localStorage = ref.read(localStorageProvider);

    final key = _getKey(relayUrl);
    final reachabilityInfo = localStorage.getStringList(key);
    if (reachabilityInfo == null || reachabilityInfo.isEmpty) {
      return null;
    }
    final failedToReachCount = int.parse(reachabilityInfo[0]);
    final lastFailedToReachDate = DateTime.parse(reachabilityInfo[1]);
    return RelayReachabilityInfo(
      relayUrl: relayUrl,
      failedToReachCount: failedToReachCount,
      lastFailedToReachDate: lastFailedToReachDate,
    );
  }

  void save(RelayReachabilityInfo relayReachabilityInfo) {
    final localStorage = ref.read(localStorageProvider);
    final key = _getKey(relayReachabilityInfo.relayUrl);
    localStorage.setStringList(
      key,
      [
        relayReachabilityInfo.failedToReachCount.toString(),
        relayReachabilityInfo.lastFailedToReachDate.toIso8601String(),
      ],
    );
  }

  String _getKey(String relayUrl) {
    return 'relay_reachability_info_$relayUrl';
  }
}
