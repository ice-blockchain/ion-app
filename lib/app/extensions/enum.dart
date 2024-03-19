extension EnumExtensions on Enum {
  String toShortString() => toString().split('.').last;

  static T fromShortString<T extends Enum>(List<T> values, String value) {
    return values.firstWhere((T type) => type.toShortString() == value);
  }
}
