/// Marker‑interface for models that work with Optimistic UI.
abstract interface class OptimisticModel {
  /// Unique identifier of the instance.
  String get optimisticId;

  bool equals(covariant OptimisticModel other) => this == other;
}
