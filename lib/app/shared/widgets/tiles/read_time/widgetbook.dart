import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/tiles/read_time/read_time_tile.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'base case',
  type: ReadTimeTile,
)
Widget baseUseCase(BuildContext context) {
  return ColoredBox(
    color: context.theme.appColors.onTerararyFill,
    // Set the background color to white
    child: ReadTimeTile(
      minutesToRead: context.knobs.int.slider(
        label: 'Minutes To Read',
        initialValue: 7,
        max: 120,
      ),
    ),
  );
}
