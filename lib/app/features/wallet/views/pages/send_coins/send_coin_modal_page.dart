import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/coins_list_view.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SendCoinModalPage extends IceSimplePage {
  const SendCoinModalPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return SheetContent(
      body: const CoinsListView(),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
