// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:ion/app/extensions/extensions.dart';

class PollPickerColumn extends StatelessWidget {
  const PollPickerColumn({
    required this.maxCount,
    required this.controller,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelectedItemChanged,
    this.alignment = MainAxisAlignment.start,
    super.key,
  });

  final int maxCount;
  final FixedExtentScrollController controller;
  final ValueNotifier<int> selectedValue;
  final String Function(int) labelBuilder;
  final ValueChanged<int> onSelectedItemChanged;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        SizedBox(
          height: 178.0.s,
          width: 40.0.s,
          child: CupertinoPicker(
            itemExtent: 34.0.s,
            scrollController: controller,
            onSelectedItemChanged: (int index) {
              selectedValue.value = index;
              onSelectedItemChanged(index);
            },
            selectionOverlay: Container(),
            children: List<Widget>.generate(maxCount, (int index) {
              return Center(
                child: Text(
                  index.toString(),
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.primaryText,
                    fontSize: 23.0.s,
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          width: 70.0.s,
          child: Text(
            labelBuilder(selectedValue.value),
            textAlign: TextAlign.left,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.primaryText,
              fontSize: 23.0.s,
            ),
          ),
        ),
      ],
    );
  }
}
