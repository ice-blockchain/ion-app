import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: TextInput,
)
Widget regularTextInputUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextInput(
            onTextChanged: (String text) {},
          ),
          TextInput(
            onTextChanged: (String text) {},
          ),
        ],
      ),
    ),
  );
}
