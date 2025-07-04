// SPDX-License-Identifier: ice License 1.0

class UserFetchState {
  UserFetchState({
    required this.pubkey,
    this.emptyFetchCount = 0,
    this.lastFetchTime,
    this.lastContentTime,
  });

  final String pubkey;
  final int emptyFetchCount;
  final DateTime? lastFetchTime;
  final DateTime? lastContentTime;
}
