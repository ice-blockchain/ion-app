// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/code_types.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class CodeBlockTypeItem extends StatelessWidget {
  const CodeBlockTypeItem({
    required this.type,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final CodeBlockType type;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsetsDirectional.only(
          start: 8.0.s,
          end: isSelected ? 4.0.s : 8.0.s,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.theme.appColors.onTerararyFill
              : context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadius.circular(12.0.s),
          border: Border.all(
            color: context.theme.appColors.onTerararyFill,
          ),
        ),
        child: Row(
          children: [
            Text(
              type.getTitle(context),
              style: context.theme.appTextThemes.caption.copyWith(
                color: isSelected
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors.terararyText,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 4.0.s),
              Assets.svg.iconArrowRight.icon(
                color: context.theme.appColors.primaryAccent,
                size: 14.0.s,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
