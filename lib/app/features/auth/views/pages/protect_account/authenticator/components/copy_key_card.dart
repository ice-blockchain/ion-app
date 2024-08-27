import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class CopyKeyCard extends HookWidget {
  const CopyKeyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final textTheme = context.theme.appTextThemes;

    final isCopied = useState(false);

    return RoundedCard.filled(
      padding: EdgeInsets.symmetric(vertical: 40.0.s),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.icons.iconFieldIdentitykey.icon(
                size: 16.0.s,
                color: context.theme.appColors.onTertararyBackground,
              ),
              SizedBox(width: 6.0.s),
              Text(
                locale.authenticator_setup_key,
                style: textTheme.caption2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0.s),
          Text(
            '395-838402-28385-432',
            style: textTheme.subtitle,
          ),
          SizedBox(height: 20.0.s),
          Button(
            minimumSize: Size(148.0.s, 48.0.s),
            leadingIcon: isCopied.value
                ? Assets.images.icons.iconBlockCheckGreen.icon()
                : Assets.images.icons.iconBlockCopyBlue.icon(),
            borderColor: isCopied.value
                ? context.theme.appColors.success
                : context.theme.appColors.strokeElements,
            onPressed: () {
              isCopied.value = true;
              Future<void>.delayed(const Duration(seconds: 3)).then((_) {
                isCopied.value = false;
              });
            },
            label: Text(
              isCopied.value ? context.i18n.wallet_copied : context.i18n.wallet_copy,
              style: context.theme.appTextThemes.body.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            type: ButtonType.secondary,
          ),
        ],
      ),
    );
  }
}
