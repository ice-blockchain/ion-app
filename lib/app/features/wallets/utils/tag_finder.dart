// SPDX-License-Identifier: ice License 1.0

/// Finds the value of a request tag if it exists in the event tags
String? findTagValue(List<List<String>> tags, String tagToFind) {
  for (final tag in tags) {
    if (tag.length >= 2 && tag[0] == tagToFind) {
      return tag[1];
    }
  }
  return null;
}
