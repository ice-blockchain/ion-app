class UserQueryState {
  UserQueryState({
    this.emptyFetchCount = 0,
    this.lastFetchTime,
    this.lastContentTime,
  });

  final int emptyFetchCount;
  final DateTime? lastFetchTime;
  final DateTime? lastContentTime;
}
