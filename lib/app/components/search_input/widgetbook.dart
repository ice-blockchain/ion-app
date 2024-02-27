import 'package:flutter/material.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: SearchInput,
)
Widget regularSearchInputUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SearchInput(
            onTextChanged: (String text) {},
          ),
          SearchInput(
            onTextChanged: (String text) {},
            loading: true,
          ),
        ],
      ),
    ),
  );
}
