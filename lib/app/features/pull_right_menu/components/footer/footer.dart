import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/pull_right_menu/components/footer/footer_action.dart';
import 'package:ice/generated/assets.gen.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.all(20.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FooterAction(
              onPressed: () {},
              assetName: Assets.images.icons.iconProfileSettings.path,
              label: context.i18n.profile_privacy,
            ),
            SizedBox(height: 20.0.s),
            FooterAction(
              onPressed: () {},
              assetName: Assets.images.icons.iconProfileHelp.path,
              label: context.i18n.profile_help,
            ),
          ],
        ),
      ),
    );
  }
}
