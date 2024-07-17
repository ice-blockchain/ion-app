import 'package:flutter/material.dart';
import 'package:ice/app/extensions/iterable.dart';

class SeparatedColumn extends Column {
  SeparatedColumn({
    required Widget separator,
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const [],
  }) : super(
          children: children.intersperse(separator).toList(),
        );
}
