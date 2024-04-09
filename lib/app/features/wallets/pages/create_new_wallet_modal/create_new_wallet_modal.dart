import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_clear_button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class CreateNewWalletModal extends IceSimplePage {
  const CreateNewWalletModal(super.route, super.payload);

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    _,
  ) {
    final ValueNotifier<String> walletName = useState('');
    final TextEditingController controller = useTextEditingController();

    return SheetContentScaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NavigationAppBar.modal(
              title: context.i18n.wallet_create_new,
              actions: const <Widget>[NavigationCloseButton()],
            ),
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(top: 21.0.s, bottom: 24.0.s),
                child: TextInput(
                  controller: controller,
                  onChanged: (String newValue) => walletName.value = newValue,
                  labelText: context.i18n.wallet_name,
                  suffixIcon: walletName.value.isEmpty
                      ? null
                      : TextInputIcons(
                          icons: <Widget>[
                            TextInputClearButton(
                              controller: controller,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            ScreenSideOffset.small(
              child: Button(
                onPressed: () {
                  ref.read(walletsDataNotifierProvider.notifier).walletData =
                      WalletData(
                    id: DateTime.now().toString(),
                    name: walletName.value,
                    icon:
                        'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                    balance: 0.0,
                  );
                  context.pop();
                },
                label: Text(context.i18n.wallet_create),
                disabled: walletName.value.isEmpty,
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0.s),
          ],
        ),
      ),
    );
  }
}
