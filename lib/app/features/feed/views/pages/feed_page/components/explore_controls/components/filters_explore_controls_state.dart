import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class FiltersExploreControlsState extends HookWidget {
  const FiltersExploreControlsState();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<SampleItem> selected = useState(SampleItem.itemOne);
    return Row(
      children: <Widget>[
        DropDownMenu(
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return Button.compact(
              leadingIcon: ButtonIcon(
                Assets.images.icons.iconArrowRight.path,
                size: 30.0.s,
              ),
              label: Text(
                selected.value.toString(),
              ),
              trailingIcon: Icon(
                controller.isOpen
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
              ),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            );
          },
          menuChildren: <Widget>[
            MenuItemButton(
              onPressed: () => selected.value = SampleItem.itemOne,
              leadingIcon: const Icon(Icons.account_balance_sharp),
              child: const Text('Item one'),
            ),
            MenuItemButton(
              onPressed: () => selected.value = SampleItem.itemTwo,
              child: const Row(
                children: <Widget>[
                  Icon(Icons.account_balance_sharp),
                  Text('Item long eeeeee'),
                ],
              ),
            ),
            MenuItemButton(
              onPressed: () => selected.value = SampleItem.itemThree,
              leadingIcon: const Icon(Icons.account_balance_sharp),
              child: const Text('Item three'),
            ),
          ],
        ),
      ],
    );
  }
}
