// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/nft_sorting_type.dart';
import 'package:ice/app/features/wallet/views/pages/nfts_sorting_modal/components/sorting_button/sorting_button.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class NftsSortingModal extends StatelessWidget {
  const NftsSortingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.wallet_sorting_title),
              actions: const [NavigationCloseButton()],
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
