// SPDX-License-Identifier: ice License 1.0

/// Calculates the reading time (in minutes) of a given content.
int calculateReadingTime(String? content) {
  if (content == null) {
    return 1; // Default reading time
  }

  const wordsPerMinute = 200;
  final words = content.split(' ').length;

  return (words / wordsPerMinute).ceil();
}
