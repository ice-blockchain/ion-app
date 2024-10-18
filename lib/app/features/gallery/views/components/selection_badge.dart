// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class SelectionBadge extends StatelessWidget {
  const SelectionBadge({
    required this.isSelected,
    required this.selectionOrder,
    super.key,
  });

  final bool isSelected;
  final String selectionOrder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.0.s,
      height: 20.0.s,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? context.theme.appColors.primaryAccent : Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected
              ? null
              : Border.all(
                  color: context.theme.appColors.secondaryText,
                  width: 1.0.s,
                ),
        ),
        child: isSelected
            ? Center(
                child: Text(
                  selectionOrder,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.secondaryBackground,
                    fontSize: 12.0.s,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
