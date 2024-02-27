import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  double get iconSize => 16.0.s;

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
            child: ImageIcon(
              AssetImage(Assets.images.icons.iconSheetClose.path),
              color: context.theme.appColors.tertararyText,
              // size: iconSize,
            ),
            onTap: () {
              context.pop();
            },
          ),
        ),
      ],
    );
  }
}
