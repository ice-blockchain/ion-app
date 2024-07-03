import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/terms_privacy/terms_privacy.dart';
import 'package:ice/app/features/auth/views/pages/enter_code/components/enter_code_fields.dart';
import 'package:ice/app/features/auth/views/pages/enter_code/components/resend_timer.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/router/hooks/use_memoized_bottom_offset.dart';
import 'package:ice/app/router/hooks/use_sheet_full_height.dart';
import 'package:ice/generated/assets.gen.dart';

class EnterCode extends IcePage {
  const EnterCode({super.key});

  // const EnterCode(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    const phoneNumber = '+101234567890';

    final sheetFullHeight = useSheetFullHeight(context);
    final bottomOffset = useMemoizedBottomOffset(context);

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
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
                  title: context.i18n.enter_code_title,
                  icon: Assets.images.misc.authEnterCode.icon(
                    size: 74.0.s,
                  ),
                  iconOffset: 12.0.s,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      context.i18n.enter_code_description,
                      style: context.theme.appTextThemes.subtitle2.copyWith(
                        color: context.theme.appColors.secondaryText,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0.s),
                      child: Text(
                        phoneNumber,
                        style: context.theme.appTextThemes.subtitle.copyWith(
                          color: context.theme.appColors.secondaryText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0.s),
                      child: const EnterCodeFields(),
                    ),
                  ],
                ),
                const ResendTimer(),
                Assets.images.logo.logoIce.icon(size: 65.0.s),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 14.0.s + bottomOffset,
                  ),
                  child: const TermsPrivacy(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
