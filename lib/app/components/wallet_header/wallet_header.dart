import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletHeader extends HookConsumerWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsets.only(
          top: 56.s,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  context.theme.appColors.tertararyBackground,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  context.theme.appColors.primaryText,
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return null;
                    }
                    return null;
                  },
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.only(
                    left: 6.s,
                    top: 6.s,
                    bottom: 6.s,
                    right: 12.s,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.s),
                    side: BorderSide(
                      color: context.theme.appColors.onTerararyFill,
                    ),
                  ),
                ),
                shadowColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                elevation: MaterialStateProperty.all<double>(0),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    Assets.images.walletWalletblue.path,
                    width: 28.s,
                    height: 28.s,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8.s),
                  Text(context.i18n.wallet_header_ice_wallet),
                  SizedBox(width: 8.s),
                  Image.asset(
                    Assets.images.selectArrows.path,
                    width: 12.s,
                    height: 12.s,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Button.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    Assets.images.fieldSearch.path,
                    width: 24.s,
                    height: 24.s,
                  ),
                  type: ButtonType.outlined,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(40.s, 40.s),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(40.s, 40.s),
                    ),
                  ),
                ),
                SizedBox(width: 12.s),
                Button.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    Assets.images.filter.path,
                    width: 24.s,
                    height: 24.s,
                  ),
                  type: ButtonType.outlined,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(40.s, 40.s),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(40.s, 40.s),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
