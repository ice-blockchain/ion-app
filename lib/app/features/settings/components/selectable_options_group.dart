// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/settings/model/selectable_option.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectableOptionsGroup<T extends SelectableOption> extends StatelessWidget {
  const SelectableOptionsGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.addSeparatorAfterLastItem = true,
    this.enabled = true,
    super.key,
  });

  final String title;
  final List<T> options;
  final List<T> selected;
  final void Function(T) onSelected;
  final bool addSeparatorAfterLastItem;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final separatorPadding = EdgeInsets.symmetric(vertical: 12.0.s);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.theme.appTextThemes.body),
        SizedBox(height: 16.0.s),
        SeparatedColumn(
          mainAxisSize: MainAxisSize.min,
          separator: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0.s),
            child: const HorizontalSeparator(),
          ),
          children: options
              .map(
                (e) => _OptionItem(
                  icon: e.getIcon(context),
                  title: e.getLabel(context),
                  onTap: () => onSelected(e),
                  isSelected: selected.contains(e),
                  enabled: enabled,
                ),
              )
              .toList(),
        ),
        if (addSeparatorAfterLastItem) Padding(
          padding: separatorPadding.copyWith(bottom: 0),
          child: const HorizontalSeparator(),
        ),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  const _OptionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.enabled,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String title;
  final Widget icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.0.s,
      child: ListItem(
        contentPadding: EdgeInsets.zero,
        onTap: enabled ? onTap : null,
        backgroundColor: context.theme.appColors.secondaryBackground,
        leading: Button.icon(
          backgroundColor: context.theme.appColors.secondaryBackground,
          borderColor: context.theme.appColors.onTerararyFill,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0.s),
          ),
          size: 36.0.s,
          onPressed: enabled ? onTap : () {},
          icon: icon,
        ),
        title: Text(title, style: context.theme.appTextThemes.body),
        trailing: isSelected
            ? Assets.svg.iconBlockCheckboxOn.icon(
                color: enabled ? null : context.theme.appColors.sheetLine,
              )
            : Assets.svg.iconBlockCheckboxOff.icon(),
      ),
    );
  }
}
