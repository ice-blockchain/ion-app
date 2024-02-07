import 'package:flutter/material.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'with green color',
  type: Button,
)
Widget greenContainerUseCase(BuildContext context) {
  return Center(
    child: Button(
      type: ButtonType.outlined,
      label: const Text('123'),
      onPressed: () {},
    ),
  );
}

@widgetbook.UseCase(
  name: 'with red color',
  type: Button,
)
Widget redContainerUseCase(BuildContext context) {
  return Center(
    child: Button(
      type: ButtonType.disabled,
      label: const Text('Text'),
      onPressed: () {},
    ),
  );
}
