// SPDX-License-Identifier: ice License 1.0

/// Describes a business intent for optimistic update.
/// Defines what is changed and (optionally) how to sync.
abstract interface class OptimisticIntent<T> {
  /// Returns the optimistic (locally updated) state.
  T optimistic(T current);

  /// Optionally, syncs the update (delegated to strategy in most cases).
  Future<T> sync(T prev, T next);
}
