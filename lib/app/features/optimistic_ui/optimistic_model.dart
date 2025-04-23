// SPDX-License-Identifier: ice License 1.0

/// Contract for models used in optimistic UI operations.
///
/// Implement this interface for any model that participates in optimistic updates.
/// The [optimisticId] must uniquely identify the entity for correct state tracking.
abstract interface class OptimisticModel {
  /// Unique identifier for optimistic state tracking.
  String get optimisticId;
}
