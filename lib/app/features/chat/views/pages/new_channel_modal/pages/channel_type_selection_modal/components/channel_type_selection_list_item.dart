// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/selection_list_item.dart';

class ChannelTypeSelectionListItem extends StatelessWidget {
  const ChannelTypeSelectionListItem({
    required this.channelType,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  final ChannelType channelType;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    final borderRadius = 16.0.s;

    return Stack(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                    channelType.getDesc(context),
                    style: textStyles.body.copyWith(color: colors.quaternaryText),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        SelectionListItem(
          title: channelType.getTitle(context),
          onTap: onTap,
          iconAsset: channelType.iconAsset,
          isSelected: isSelected,
        ),
      ],
    );
  }
}
