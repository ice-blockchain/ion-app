import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';

class FeedCategoriesDropdown extends HookWidget {
  const FeedCategoriesDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<FeedCategory> selected = useState(FeedCategory.feed);

    return DropDownMenu(
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return Button.dropdown(
          leadingIcon: ButtonIconFrame(
            color: selected.value.getColor(context),
            icon: selected.value.getIcon(context),
          ),
          label: Text(
            selected.value.getLabel(context),
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
            onPressed: () => selected.value = category,
            child: Row(
              children: <Widget>[
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
