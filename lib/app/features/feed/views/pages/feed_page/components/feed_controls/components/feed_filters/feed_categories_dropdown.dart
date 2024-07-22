import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/providers/feed_category_provider.dart';

class FeedCategoriesDropdown extends HookConsumerWidget {
  const FeedCategoriesDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedCategory = ref.watch(feedCategoryNotifierProvider);
    return DropDownMenu(
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return Button.dropdown(
          leadingIcon: ButtonIconFrame(
            color: feedCategory.getColor(context),
            icon: feedCategory.getIcon(context),
          ),
          label: Text(
            feedCategory.getLabel(context),
          ),
          opened: controller.isOpen,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: <MenuItemButton>[
        for (final FeedCategory category in FeedCategory.values)
          MenuItemButton(
            onPressed: () {
              ref.read(feedCategoryNotifierProvider.notifier).category = category;
            },
            child: Row(
              children: [
                ButtonIconFrame(
                  color: category.getColor(context),
                  icon: category.getIcon(context),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.0.s),
                  child: Text(category.getLabel(context)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
