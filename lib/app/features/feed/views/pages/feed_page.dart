import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/components/explore_controls/explore_controls.dart';
import 'package:ice/generated/assets.gen.dart';

enum FeedType { feed, videos, stories }

class FeedPage extends IceSimplePage {
  const FeedPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<FeedType> selected = useState(FeedType.feed);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ExploreControls(),
            DropDownMenu(
              builder: (
                BuildContext context,
                MenuController controller,
                Widget? child,
              ) {
                return Button(
                  trailingIcon: Icon(
                    controller.isOpen
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                  ),
                  leadingIcon: ButtonIcon(
                    Assets.images.icons.iconBadgeIcelogo.path,
                    size: 30.0.s,
                  ),
                  label: Text(
                    selected.value.toString(),
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
                  onPressed: () => selected.value = FeedType.feed,
                  leadingIcon: const Icon(Icons.account_balance_sharp),
                  child: const Text('Feed'),
                ),
                MenuItemButton(
                  onPressed: () => selected.value = FeedType.videos,
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.account_balance_sharp),
                      Text('Videos'),
                    ],
                  ),
                ),
                MenuItemButton(
                  onPressed: () => selected.value = FeedType.stories,
                  leadingIcon: const Icon(Icons.account_balance_sharp),
                  child: const Text('Stories'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
