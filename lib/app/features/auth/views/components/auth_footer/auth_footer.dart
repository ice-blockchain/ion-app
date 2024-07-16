import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:ice/l10n/i10n.dart';

enum FooterLink {
  terms,
  privacy,
  unknown;

  factory FooterLink.fromKey(String key) {
    return switch (key) {
      'privacy_policy' => FooterLink.privacy,
      'terms_of_service' => FooterLink.terms,
      _ => FooterLink.unknown
    };
  }

  VoidCallback get onPressed {
    return switch (this) {
      FooterLink.terms => () {},
      FooterLink.privacy => () {},
      _ => () {}
    };
  }

  String label(BuildContext context) {
    return switch (this) {
      FooterLink.terms => context.i18n.auth_terms_of_service,
      FooterLink.privacy => context.i18n.auth_privacy_policy,
      _ => ''
    };
  }
}

class AuthFooter extends HookWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final termsPrivacyTextSpan = useMemoized(
      () => replaceString(
        context.i18n.auth_privacy,
        tagRegex('link', isSingular: false),
        (String text, int index) {
          final link = FooterLink.fromKey(text);
          return TextSpan(
            text: link.label(context),
            style: context.theme.appTextThemes.caption3.copyWith(
              color: context.theme.appColors.primaryAccent,
            ),
            recognizer: TapGestureRecognizer()..onTap = link.onPressed,
          );
        },
      ),
    );

    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: context.i18n.auth_secured_by),
              const TextSpan(text: ' '),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Assets.images.icons.iconLoginIdentity.icon(size: 20.0.s),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: context.i18n.auth_identity_io,
                style: TextStyle(
                  color: context.theme.appColors.primaryAccent,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
        SizedBox(height: 20.0.s),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 220.0.s),
          child: Text.rich(
            termsPrivacyTextSpan,
            textAlign: TextAlign.center,
            style: context.theme.appTextThemes.caption3.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ),
      ],
    );
  }
}
