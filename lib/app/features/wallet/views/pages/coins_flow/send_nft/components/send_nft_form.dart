import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/slider/app_slider.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/arrival_time/arrival_time.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/network_button.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/network_fee.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/providers/send_nft_form_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SendNftForm extends IcePage {
  const SendNftForm({super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendNftFormControllerProvider);

    return SheetContent(
      backgroundColor: colors.secondaryBackground,
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: locale.send_nft_title,
                  actions: const <Widget>[
                    NavigationCloseButton(),
                  ],
                ),
              ),
              ScreenSideOffset.small(
                child: Column(
                  children: <Widget>[
                    // NftButton(
                    //   nftData: formController.selectedNft,
                    //   onTap: () {
                    //     NftSendRoute().push<void>(context);
                    //   },
                    // ),
                    SizedBox(height: 12.0.s),
                    NetworkButton(
                      networkType: formController.selectedNetwork,
                      onTap: () {
                        NetworkSelectSendRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 17.0.s),
                    const ArrivalTime(),
                    SizedBox(height: 12.0.s),
                    AppSlider(
                      initialValue: formController.arrivalTime.toDouble(),
                      onChanged: (double value) {
                        ref
                            .read(sendNftFormControllerProvider.notifier)
                            .updateArrivalTime(value.toInt());
                      },
                    ),
                    SizedBox(height: 8.0.s),
                    const NetworkFee(),
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
                        child: Assets.images.icons.iconButtonNext.icon(),
                      ),
                      onPressed: () {
                        // NftSendFormConfirmationRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 16.0.s),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
