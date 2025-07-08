// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';

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
Map<String, List<String>> findMostMatchingOptions(Map<String, List<String>> keysToOptions) {
  if (keysToOptions.isEmpty) {
    return {};
  }

  /// Transforms
  /// {
  ///   "Key1": ["Option1", "Option2"],
  ///   "Key2": ["Option2", "Option3"]
  /// }
  /// to
  /// {
  ///   "Option1": ["Key1"],
  ///   "Option2": ["Key1", "Key2"],
  ///   "Option3": ["Key2"]
  /// }
  final optionsToKeys = <String, Set<String>>{};
  for (final entry in keysToOptions.entries) {
    for (final option in entry.value) {
      optionsToKeys.putIfAbsent(option, () => <String>{}).add(entry.key);
    }
  }

  /// Looking for the "best" entry - entry with most keys
  final maxEntry = maxBy(optionsToKeys.entries, (entry) => entry.value.length);

  if (maxEntry == null) {
    /// If all options for all the remaining keys are empty
    return {};
  }

  /// Removing the keys that are kept in the `maxEntry`
  /// from the initial key:options structure
  final leftKeysToOptions = {...keysToOptions}
    ..removeWhere((key, value) => maxEntry.value.contains(key));

  /// If there are any remaining unhandled keys, process them recursively
  if (leftKeysToOptions.isNotEmpty) {
    return {maxEntry.key: maxEntry.value.toList(), ...findMostMatchingOptions(leftKeysToOptions)};
  }

  return {maxEntry.key: maxEntry.value.toList()};
}

/// Calculates the reading time (in minutes) of a given content.
int calculateReadingTime(String? content) {
  if (content == null) {
    return 1; // Default reading time
  }

  const wordsPerMinute = 200;
  final words = content.split(' ').length;

  return (words / wordsPerMinute).ceil();
}
