import 'package:flutter/foundation.dart';

abstract class LabelerResult {
  List<String> get labels;
}

class TextLabelerResult implements LabelerResult {
  @override
  final List<String> labels;

  final String input;

  TextLabelerResult({
    required this.labels,
    required this.input,
  });

  @override
  bool operator ==(covariant TextLabelerResult other) {
    if (identical(this, other)) return true;

    return listEquals(other.labels, labels) && other.input == input;
  }

  @override
  int get hashCode => labels.hashCode ^ input.hashCode;

  @override
  String toString() => 'TextLabelerResult(labels: $labels, input: $input)';

  TextLabelerResult copyWith({
    List<String>? labels,
    String? input,
  }) {
    return TextLabelerResult(
      labels: labels ?? this.labels,
      input: input ?? this.input,
    );
  }
}
