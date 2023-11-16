import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/terms_privacy/terms_privacy.dart';
import 'package:ice/generated/assets.gen.dart';

class CheckEmail extends HookConsumerWidget {
  const CheckEmail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String email = 'hello@ice.io';
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultEdgeInset),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 65,
                ),
                Image.asset(
                  Assets.images.iceRound.path,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Check email',
                  style: context.theme.appTextThemes.headline1,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('We emailed a magic link to'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      email,
                      style: context.theme.appTextThemes.subtitle,
                    ),
                    Image.asset(Assets.images.link.path),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                  child: Text(
                    'Click the link and enter the code to log in or sign up.',
                    textAlign: TextAlign.center,
                    style: context.theme.appTextThemes.subtitle2.copyWith(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            Image.asset(
              Assets.images.iceRound.path,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: TermsPrivacy(),
            ),
          ],
        ),
      ),
    );
  }
}
