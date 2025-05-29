// SPDX-License-Identifier: ice License 1.0

extension Timestamp on int {
  DateTime get toDateTime {
    return switch (toString().length) {
      // If the timestamp is 10 digits, it's in seconds
      10 => DateTime.fromMillisecondsSinceEpoch(this * 1000),
      // If the timestamp is 13 digits, it's in milliseconds
      13 => DateTime.fromMillisecondsSinceEpoch(this),
      // If the timestamp is 16 digits, assume it's in microseconds
      16 => DateTime.fromMicrosecondsSinceEpoch(this),
      _ => throw FormatException(
          'Invalid timestamp format: ${toString()} length: ${toString().length}',
        ),
    };
  }
}
