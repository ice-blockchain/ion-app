import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

class OneContactItem extends StatelessWidget {
  const OneContactItem({
    required this.contactData,
    super.key,
  });

  final ContactData contactData;

  static double get imageWidth => 60.0.s;

  static double get iceLogoSize => 24.0.s;

  static double get iceLogoBorderRadius => 6.0.s;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Avatar(
              size: imageWidth,
              imageUrl: contactData.icon,
              borderRadius: BorderRadius.circular(14.0.s),
            ),
            if (contactData.hasIceAccount == true)
              Positioned(
                right: -4.0.s,
                bottom: -4.0.s,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(iceLogoBorderRadius),
                    border: Border.all(
                      color: context.theme.appColors.secondaryBackground,
                      width: 2.0.s,
                    ),
                  ),
                  position: DecorationPosition.foreground,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(iceLogoBorderRadius),
                    child: Assets.images.icons.iconBadgeIcelogo.icon(
                      size: iceLogoSize,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(
          height: 8.0.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contactData.name,
              style: context.theme.appTextThemes.title,
            ),
            if (contactData.isVerified ?? false) ...[
              SizedBox(width: 4.0.s),
              Assets.images.icons.iconBadgeVerify.icon(size: 16.0.s),
            ],
          ],
        ),
        SizedBox(
          height: 4.0.s,
        ),
        Text(
          contactData.hasIceAccount
              ? prefixUsername(
                  username: contactData.nickname,
                  context: context,
                )
              : contactData.phoneNumber ?? '',
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.tertararyText),
        ),
        if (!contactData.hasIceAccount)
          SizedBox(
            height: 34.0.s,
          ),
        if (!contactData.hasIceAccount)
          Text(
            context.i18n.wallet_friends_does_not_have_account,
            style: context.theme.appTextThemes.subtitle2,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
