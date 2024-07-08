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
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class CreateNewWalletModal extends IcePage {
  const CreateNewWalletModal({super.key});

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    final walletName = useState('');
    final controller = useTextEditingController();

    return SheetContent(
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
                    icon: mockWalletIconUrl,
                    balance: 0,
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
