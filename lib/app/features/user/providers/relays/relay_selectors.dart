// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';

/// Finds the options that have the most associated keys from a given map of keys to their associated options.
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

/// Finds the options that have the highest priority based on a given list of options priority.
///
/// Example:
/// If the input is:
/// {
///   "Key1": ["Option1", "Option2", "Option3", "Option7"],
///   "Key2": ["Option4", "Option5", "Option6", "Option7"],
///   "Key3": ["Option8", "Option9", "Option10", "Option11"]
/// }
/// And options priority is ["Option9", "Option8", "Option7", "Option6", "Option5", "Option4", "Option3", "Option2", "Option1"],
/// so from the most preferred to the least preferred.
///
/// The output will be:
/// {
///   "Option9": ["Key3"],
///   "Option7": ["Key2", "Key1"]
/// }
Map<String, List<String>> findPriorityOptions(
  Map<String, List<String>> keysToOptions, {
  required List<String> optionsPriority,
}) {
  if (keysToOptions.isEmpty || optionsPriority.isEmpty) {
    return {};
  }

  // Find the highest priority option present in the current keysToOptions
  String? highestPriorityOption;
  for (final option in optionsPriority) {
    if (keysToOptions.values.any((options) => options.contains(option))) {
      highestPriorityOption = option;
      break;
    }
  }

  if (highestPriorityOption == null) {
    return {};
  }

  // Find all keys that have this option
  final matchingKeys = keysToOptions.entries
      .where((entry) => entry.value.contains(highestPriorityOption))
      .map((entry) => entry.key)
      .toList();

  final remainingKeysToOptions = {...keysToOptions}
    ..removeWhere((key, _) => matchingKeys.contains(key));

  return {
    highestPriorityOption: matchingKeys,
    ...findPriorityOptions(
      remainingKeysToOptions,
      optionsPriority: optionsPriority,
    ),
  };
}
