// SPDX-License-Identifier: ice License 1.0

DateTime fromTimestamp(int timestamp) {
  if (timestamp.toString().length <= 10) {
    // If the timestamp is in seconds, convert to milliseconds
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  } else {
    // If the timestamp is already in milliseconds, use it directly
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
