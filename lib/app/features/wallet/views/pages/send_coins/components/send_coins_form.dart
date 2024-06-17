import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_text_button.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/slider/app_slider.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/address_input_field.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/arrival_time/arrival_time.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/button/coin_button.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/button/network_button.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/network_fee.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/model/form_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';
import 'package:ice/generated/app_localizations.dart';
import 'package:ice/generated/assets.gen.dart';

class SendCoinsForm extends IceSimplePage {
  const SendCoinsForm(super.route, super.payload);

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final AppColorsExtension colors = context.theme.appColors;
    final AppTextThemesExtension textTheme = context.theme.appTextThemes;
    final I18n locale = context.i18n;

    final FormData formController = ref.watch(sendCoinsFormControllerProvider);

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: FractionallySizedBox(
        heightFactor: 0.9,
        child: KeyboardDismissOnTap(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.s),
                  child: NavigationAppBar.screen(
                    title: locale.wallet_send_coins,
                    actions: const <Widget>[
                      NavigationCloseButton(),
                    ],
                  ),
                ),
                ScreenSideOffset.small(
                  child: Column(
                    children: <Widget>[
                      CoinButton(
                        coinData: formController.selectedCoin,
                        onTap: () {
                          IceRoutes.coinSend.push(
                            context,
                          );
                        },
                      ),
                      SizedBox(height: 12.0.s),
                      NetworkButton(
                        networkType: formController.selectedNetwork,
                        onTap: () {
                          IceRoutes.networkSelect.push(
                            context,
                          );
                        },
                      ),
                      SizedBox(height: 12.0.s),
                      AddressInputField(
                        onContactListPressed: () {},
                        onScanPressed: () {},
                      ),
                      SizedBox(height: 12.0.s),
                      TextInput(
                        labelText: locale.wallet_usdt_amount,
                        initialValue: '350.00',
                        suffixIcon: TextInputTextButton(
                          onPressed: () {},
                          label: locale.wallet_max,
                        ),
                      ),
                      SizedBox(height: 10.0.s),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '~ 349.99 USD',
                          style: textTheme.caption2.copyWith(
                            color: colors.tertararyText,
                          ),
                        ),
                      ),
                      SizedBox(height: 17.0.s),
                      const ArrivalTime(),
                      SizedBox(height: 12.0.s),
                      AppSlider(
                        onChanged: (double value) {},
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
                        onPressed: () {},
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
