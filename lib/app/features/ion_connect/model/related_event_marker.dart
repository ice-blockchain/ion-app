// SPDX-License-Identifier: ice License 1.0

enum RelatedEventMarker {
  reply,
  root,
  mention;

  String toValue() => name;

  static RelatedEventMarker? fromValue(String? value) {
    if (value == null) return null;

    try {
      return RelatedEventMarker.values.firstWhere(
        (marker) => marker.name == value,
      );
    } catch (_) {
      return null;
    }
  }
}
