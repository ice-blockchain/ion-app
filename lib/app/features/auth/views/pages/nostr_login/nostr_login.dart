import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/router/hooks/use_memoized_bottom_offset.dart';
import 'package:ice/app/router/hooks/use_sheet_full_height.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class NostrLogin extends IcePage {
  const NostrLogin({super.key});

  // const NostrLogin(super._route, super.payload, {super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    final sheetFullHeight = useSheetFullHeight(context);
    final bottomOffset = useMemoizedBottomOffset(context);

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      // Scroll child takes all available viewport height to
      // add space around logo (column alignment is space-between)
      // on big devices and be able to scroll on small ones.
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: sheetFullHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AuthHeader(
                  title: context.i18n.nostr_login_title,
                  description: context.i18n.nostr_login_description,
                  icon: Assets.images.logo.logoIce.icon(size: 65.0.s),
                ),
                Image.asset(
                  Assets.images.bg.ostrichlogo.path,
                  width: 256.0.s,
                  height: 160.0.s,
                ),
                Form(
                  key: _formKey,
                  child: ScreenSideOffset.large(
                    child: Column(
                      children: <Widget>[
                        TextInput(
                          scrollPadding: EdgeInsets.all(120.0.s),
                          prefixIcon: TextInputIcons(
                            hasRightDivider: true,
                            icons: <Widget>[
                              Assets.images.icons.iconFieldPrivatekey.icon(),
                            ],
                          ),
                          labelText: context.i18n.nostr_login_input_private_key,
                          controller: controller,
                          validator: (String? value) {
                            if (Validators.isEmpty(value)) return '';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 26.0.s,
                        ),
                        Button(
                          leadingIcon:
                              Assets.images.icons.iconProfileLogin.icon(),
                          onPressed: () {
                            _formKey.currentState!.validate();
                          },
                          label: Text(context.i18n.nostr_login_button),
                          mainAxisSize: MainAxisSize.max,
                        ),
                        SizedBox(
                          height: 58.0.s + bottomOffset,
                        ),
                      ],
                    ),
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
