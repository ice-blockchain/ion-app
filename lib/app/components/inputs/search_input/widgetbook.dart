// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: SearchInput,
)
Widget regularSearchInputUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
