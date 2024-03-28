import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/code_fields/code_fields.dart';
import 'package:ice/app/features/auth/views/components/terms_privacy/terms_privacy.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class CheckEmail extends IceSimplePage {
  const CheckEmail(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    const String email = 'hello@ice.io';
    final TextEditingController codeController =
        useTextEditingController(text: '1234');

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AuthHeader(
            title: context.i18n.check_email_title,
            icon: Assets.images.misc.authEnvelope.icon(size: 74.0.s),
            iconOffset: 12.0.s,
          ),
          ScreenSideOffset.large(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0.s),
                  child: Text(
                    context.i18n.check_email_subtitle,
                    style: context.theme.appTextThemes.subtitle2.copyWith(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      email,
                      style: context.theme.appTextThemes.subtitle.copyWith(
                        color: context.theme.appColors.secondaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: context.pop,
                      child:
                          Assets.images.icons.iconEditLink.icon(size: 20.0.s),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 36.0.s,
                    horizontal: 20.0.s,
                  ),
                  child: Text(
                    context.i18n.check_email_description,
                    textAlign: TextAlign.center,
                    style: context.theme.appTextThemes.subtitle2.copyWith(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                ),
                CodeFields(
                  enabled: false,
                  controller: codeController,
                ),
              ],
            ),
          ),
          Assets.images.logo.logoIce.icon(size: 65.0.s),
          Padding(
            padding: EdgeInsets.only(
              bottom: 14.0.s + MediaQuery.paddingOf(context).bottom,
            ),
            child: const TermsPrivacy(),
          ),
        ],
      ),
    );
  }
}
