import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/wallet/views/pages/nfts_sorting_modal/components/sorting_button/sorting_button.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class NftsSortingModal extends IceSimplePage {
  const NftsSortingModal(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return SheetContentScaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NavigationAppBar.modal(
              showBackButton: false,
              title: context.i18n.wallet_sorting_title,
              actions: const <Widget>[NavigationCloseButton()],
            ),
            SizedBox(
              height: 16.0.s,
            ),
            const SortingButton(
              sortingType: NftSortingType.desc,
            ),
            SizedBox(
              height: 16.0.s,
            ),
            const SortingButton(
              sortingType: NftSortingType.asc,
            ),
            SizedBox(
              height: 16.0.s,
            ),
          ],
        ),
      ),
    );
  }
}
