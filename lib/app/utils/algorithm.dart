// SPDX-License-Identifier: ice License 1.0

/// Finds the best options from a given map of keys to their associated options.
///
/// Example:
/// If the input is:
/// {
///   "Key1": ["Option1", "Option2", "Option3", "Option4"],
///   "Key2": ["Option4", "Option5", "Option6", "Option7"],
///   "Key3": ["Option8", "Option9", "Option10", "Option11"]
/// }
/// The output will be:
/// {
///   "Option4": ["Key1", "Key2"],
///   "Option8": ["Key3"]
/// }
Map<String, List<String>> findBestOptions(Map<String, List<String>> keysToOptions) {
  final optionsToKeys = <String, List<String>>{};
  for (final entry in keysToOptions.entries) {
    for (final option in entry.value) {
      optionsToKeys.putIfAbsent(option, () => <String>[]).add(entry.key);
    }
  }

  final maxEntry = optionsToKeys.entries.reduce(
    (maxEntry, currentEntry) =>
        currentEntry.value.length > maxEntry.value.length ? currentEntry : maxEntry,
  );

  final leftKeysToOptions = {...keysToOptions}
    ..removeWhere((key, value) => maxEntry.value.contains(key));

  if (leftKeysToOptions.isNotEmpty) {
    return {maxEntry.key: maxEntry.value, ...findBestOptions(leftKeysToOptions)};
  }

  return {maxEntry.key: maxEntry.value};
}
