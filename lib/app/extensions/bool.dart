extension BooleanExtension on bool? {
  bool get falseOrValue {
    return this ?? false;
  }
}
