import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/article_category.dart';
import 'package:ice/generated/assets.gen.dart';

class CategoriesRow extends StatelessWidget {
  final List<ArticleCategory> items;
  final Set<String> selectedItems;
  final ValueChanged<String> onToggle;
  final bool showAddButton;

  const CategoriesRow({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 16.0.s),
        if (showAddButton)
          Padding(
            padding: EdgeInsets.only(right: 12.0.s),
            child: Button.icon(
              borderRadius: BorderRadius.circular(12.0.s),
              backgroundColor: colors.tertararyBackground,
              size: 40.0.s,
              type: ButtonType.outlined,
              icon: Assets.svg.iconPlusCreatechannel.icon(color: colors.primaryAccent),
              onPressed: () {},
            ),
          ),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(right: 12.0.s),
            child: Button.compact(
              backgroundColor: colors.tertararyBackground,
              type: ButtonType.outlined,
              leadingIcon: item.icon.icon(
                color:
                    selectedItems.contains(item.id) ? colors.primaryAccent : colors.tertararyText,
              ),
              label: Text(
                item.name,
                style: context.theme.appTextThemes.caption.copyWith(
                  color:
                      selectedItems.contains(item.id) ? colors.primaryAccent : colors.tertararyText,
                ),
              ),
              onPressed: () => onToggle(item.id),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: selectedItems.contains(item.id)
                      ? colors.primaryAccent
                      : colors.onTerararyFill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
