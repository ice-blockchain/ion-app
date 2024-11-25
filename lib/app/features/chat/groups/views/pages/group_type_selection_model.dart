// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/groups/model/group_type.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/generated/assets.gen.dart';

class GroupTypeSelectionModal extends HookConsumerWidget {
  const GroupTypeSelectionModal({
    required this.groupType,
    required this.onUpdated,
    super.key,
  });

  final GroupType groupType;
  final void Function(GroupType groupType) onUpdated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChannelType = useState(groupType);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          actions: [
            NavigationCloseButton(onPressed: Navigator.of(context).pop),
          ],
          title: const Text('Choose group type'),
        ),
        for (final type in GroupType.values.toSet())
          ScreenSideOffset.small(
            child: Column(
              children: [
                ChannelTypeSelectionListItem(
                  groupType: type,
                  onTap: () {
                    selectedChannelType.value = type;
                    onUpdated(type);
                  },
                  isSelected: selectedChannelType.value == type,
                ),
                SizedBox(height: 16.0.s),
              ],
            ),
          ),
        ScreenBottomOffset(),
      ],
    );
  }
}

class ChannelTypeSelectionListItem extends StatelessWidget {
  const ChannelTypeSelectionListItem({
    required this.onTap,
    required this.groupType,
    required this.isSelected,
    super.key,
  });

  final GroupType groupType;
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
        SizedBox(
          width: double.maxFinite,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isSelected
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      color: colors.attentionBlock,
                    ),
                    margin: EdgeInsets.only(
                      top: ListItem.defaultConstraints.minHeight - borderRadius,
                    ),
                    padding: EdgeInsets.only(
                      left: 16.0.s,
                      right: 16.0.s,
                      top: 12.0.s + borderRadius,
                      bottom: 12.0.s,
                    ),
                    child: Text(
                      groupType.getDescription(context),
                      style: textStyles.body.copyWith(color: colors.quaternaryText),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        SelectionListItem(
          title: groupType.getTitle(context),
          onTap: onTap,
          iconAsset: groupType.icon,
          isSelected: isSelected,
        ),
      ],
    );
  }
}

class SelectionListItem extends ConsumerWidget {
  const SelectionListItem({
    required this.title,
    required this.onTap,
    required this.iconAsset,
    required this.isSelected,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final String iconAsset;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return ListItem(
      contentPadding: EdgeInsets.only(
        left: ScreenSideOffset.defaultSmallMargin,
        right: 8.0.s,
      ),
      title: Text(
        title,
        style: textStyles.body,
      ),
      backgroundColor: colors.tertararyBackground,
      onTap: onTap,
      leading: ButtonIconFrame(
        containerSize: 36.0.s,
        borderRadius: BorderRadius.circular(10.0.s),
        color: colors.onPrimaryAccent,
        icon: iconAsset.icon(
          size: 24.0.s,
          color: colors.primaryAccent,
        ),
        border: Border.fromBorderSide(
          BorderSide(color: colors.onTerararyFill, width: 1.0.s),
        ),
      ),
      trailing: Padding(
        padding: EdgeInsets.all(8.0.s),
        child: isSelected
            ? Assets.svg.iconBlockCheckboxOnblue.icon(
                color: colors.success,
              )
            : Assets.svg.iconBlockCheckboxOff.icon(
                color: colors.tertararyText,
              ),
      ),
    );
  }
}
