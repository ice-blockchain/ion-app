// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/selectable_type.dart';
import 'package:ion/app/features/chat/views/components/selection_list_item.dart';

class TypeSelectionListItem<T extends SelectableType> extends StatelessWidget {
  const TypeSelectionListItem({
    required this.type,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  final T type;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    final borderRadius = 16.0.s;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedSize(
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 300),
          child: isSelected
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
                    color: colors.attentionBlock,
                  ),
                  margin:
                      EdgeInsets.only(top: ListItem.defaultConstraints.minHeight - borderRadius),
                  padding: EdgeInsets.only(
                    left: 16.0.s,
                    right: 16.0.s,
                    top: 12.0.s + borderRadius,
                    bottom: 12.0.s,
                  ),
                  child: Text(
                    type.getDescription(context),
                    style: textStyles.body.copyWith(
                      color: colors.quaternaryText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : const SizedBox(width: double.maxFinite),
        ),
        SelectionListItem(
          title: type.getTitle(context),
          onTap: onTap,
          iconAsset: type.iconAsset,
          isSelected: isSelected,
        ),
      ],
    );
  }
}
