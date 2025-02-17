// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/nft_name.dart';
import 'package:ion/app/features/wallets/views/components/nft_picture.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/arrival_time_selector.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SendNftForm extends ConsumerWidget {
  const SendNftForm({super.key});

  static const List<Network> networkTypeValues = Network.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendAssetFormControllerProvider(type: CryptoAssetType.nft));
    final notifier = ref.read(sendAssetFormControllerProvider(type: CryptoAssetType.nft).notifier);
    final selectedNft = formController.assetData!.as<NftAssetData>()!.nft;
    final selectedContactPubkey = formController.contactPubkey;

    return SheetContent(
      backgroundColor: colors.secondaryBackground,
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: Text(locale.send_nft_title),
                  actions: const [
                    NavigationCloseButton(),
                  ],
                ),
              ),
              ScreenSideOffset.small(
                child: Column(
                  children: [
                    NftPicture(imageUrl: selectedNft.iconUrl),
                    SizedBox(height: 16.0.s),
                    NftName(
                      rank: selectedNft.rank,
                      name: selectedNft.collectionName,
                    ),
                    SizedBox(height: 16.0.s),
                    ContactInputSwitcher(
                      pubkey: selectedContactPubkey,
                      onClearTap: (pubkey) => {
                        notifier.setContact(null),
                      },
                      onContactTap: () async {
                        final pubkey = await NftSelectFriendRoute().push<String>(context);
                        pubkey?.let(notifier.setContact);
                      },
                    ),
                    SizedBox(height: 17.0.s),
                    ArrivalTimeSelector(
                      arrivalTimeInMinutes: formController.arrivalTime,
                      onArrivalTimeChanged: (int value) => ref
                          .read(sendAssetFormControllerProvider().notifier)
                          .updateArrivalTime(value),
                    ),
                    SizedBox(height: 45.0.s),
                    Button(
                      label: Text(
                        locale.button_continue,
                      ),
                      mainAxisSize: MainAxisSize.max,
                      trailingIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          colors.primaryBackground,
                          BlendMode.srcIn,
                        ),
                        child: Assets.svg.iconButtonNext.icon(),
                      ),
                      onPressed: () {
                        SendNftConfirmRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 16.0.s),
                  ],
                ),
              ),
              ScreenBottomOffset(),
            ],
          ),
        ),
      ),
    );
  }
}
