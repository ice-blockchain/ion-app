import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class FeedMainModalPage extends IceSimplePage {
  const FeedMainModalPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    final separatorWidth = MediaQuery.of(context).size.width;

    final separator = Container(
      width: separatorWidth,
      height: 0.50,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0,
          colors: <Color>[Color(0xFFC2C2C2), Color(0x47D9D9D9)],
        ),
      ),
    );

    return SheetContentScaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: ScreenSideOffset.small(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NavigationAppBar.screen(
                title: context.i18n.feed_modal_title,
                showBackButton: false,
              ),
              separator,
              SizedBox(
                height: 250.0.s,
                child: const Center(
                  child: Text('WALLET MAIN MODAL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
