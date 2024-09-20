import 'package:flutter/material.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class NothingIsFound extends StatelessWidget {
  const NothingIsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScreenSideOffset.small(
        child: EmptyList(
          asset: Assets.svg.walletIconWalletEmptysearch,
          title: context.i18n.feed_nothing_found,
        ),
      ),
    );
  }
}
