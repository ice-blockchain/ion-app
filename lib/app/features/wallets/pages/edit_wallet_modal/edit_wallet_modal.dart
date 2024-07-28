import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_clear_button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class EditWalletModal extends HookConsumerWidget {
  const EditWalletModal({required this.payload, super.key});

  final WalletData payload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletName = useState(payload.name);
    final controller = useTextEditingController(text: walletName.value);
    final isNameChanged = walletName.value != (payload.name) && walletName.value.isNotEmpty;

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.wallet_edit),
              actions: const [NavigationCloseButton()],
            ),
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(top: 21.0.s, bottom: 24.0.s),
                child: TextInput(
                  onChanged: (String newValue) => walletName.value = newValue,
                  controller: controller,
                  labelText: context.i18n.wallet_name,
                  suffixIcon: walletName.value.isEmpty
                      ? null
                      : TextInputIcons(
                          icons: [
                            TextInputClearButton(
                              controller: controller,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            ScreenSideOffset.small(
              child: isNameChanged
                  ? Button(
                      onPressed: () {
                        ref
                            .read(walletsRepositoryProvider)
                            .updateWallet(payload.copyWith(name: walletName.value));

                        context.pop();
                      },
                      label: Text(context.i18n.button_save),
                      mainAxisSize: MainAxisSize.max,
                    )
                  : Button(
                      onPressed: () {
                        DeleteWalletRoute($extra: payload).replace(context);
                      },
                      leadingIcon: Assets.images.icons.iconBlockDelete
                          .icon(color: context.theme.appColors.onPrimaryAccent),
                      label: Text(context.i18n.wallet_delete),
                      mainAxisSize: MainAxisSize.max,
                      backgroundColor: context.theme.appColors.attentionRed,
                    ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0.s),
          ],
        ),
      ),
    );
  }
}
