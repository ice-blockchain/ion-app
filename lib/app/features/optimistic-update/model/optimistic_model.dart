/// Abstract class for entities supporting optimistic updates.
/// Must be implemented by all models used with optimistic update logic.
abstract class OptimisticModel {
  String get id;
}
