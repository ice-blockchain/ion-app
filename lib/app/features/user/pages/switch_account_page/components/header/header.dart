import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20.0.s),
          child: Text(
            context.i18n.profile_switch_user_header,
            style: context.theme.appTextThemes.subtitle,
          ),
        ),
        Positioned(
          right: 16.0.s,
          top: 20.0.s,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
            child: Assets.images.icons.iconSheetClose
                .icon(color: context.theme.appColors.tertararyText),
            onTap: () {
              context.pop();
            },
          ),
        ),
      ],
    );
  }
}
