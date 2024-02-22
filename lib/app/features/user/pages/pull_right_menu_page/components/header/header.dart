import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/header/header_action.dart';
import 'package:ice/generated/assets.gen.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderAction(
              onPressed: () {
                context.pop();
              },
              assetName: Assets.images.icons.iconChatBack.path,
            ),
            const Spacer(),
            HeaderAction(
              onPressed: () {},
              assetName: Assets.images.icons.iconChatDarkmode.path,
            ),
            SizedBox(width: 12.0.s),
            HeaderAction(
              onPressed: () {},
              assetName: Assets.images.icons.iconSwitchProfile.path,
            ),
          ],
        ),
      ),
    );
  }
}
