// SPDX-License-Identifier: ice License 1.0

/// Defines how to synchronize optimistic changes with the backend.
abstract interface class SyncStrategy<T> {
  /// Sends the optimistic update and returns the final state.
  Future<T> send(T previous, T optimistic);
}
