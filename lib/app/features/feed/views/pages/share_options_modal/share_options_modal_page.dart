import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/share_modal_page_content.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ShareOptionsPage extends IcePage<String?> {
  const ShareOptionsPage(super.route, super.payload, {super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, String? payload) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              showBackButton: false,
              title: context.i18n.feed_share_via,
              actions: const [
                NavigationCloseButton(),
              ],
            ),
          ),
          ScreenSideOffset.small(
            child: Row(
              children: [
                Expanded(
                  child: SearchInput(
                    onTextChanged: (String text) {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0.s,
          ),
          const Expanded(child: ShareModalPageContent()),
        ],
      ),
    );
  }
}
