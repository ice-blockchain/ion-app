import 'package:flutter/foundation.dart';
import 'package:ion_content_labeler/ion_content_labeler.dart';

abstract class LabelerResult {
  List<Label> get labels;
}

class TextLabelerResult implements LabelerResult {
  @override
  final List<Label> labels;

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
    List<Label>? labels,
    String? input,
  }) {
    return TextLabelerResult(
      labels: labels ?? this.labels,
      input: input ?? this.input,
    );
  }
}
