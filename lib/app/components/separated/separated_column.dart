import 'package:flutter/material.dart';
import 'package:ice/app/extensions/iterable.dart';

class SeparatedColumn extends Column {
  SeparatedColumn({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
    required Widget separator,
  }) : super(
          children: children.intersperse(separator).toList(),
        );
}
