import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletHeader extends HookConsumerWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.large(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 56,
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
                  const EdgeInsets.only(left: 6, top: 6, bottom: 6, right: 12),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                    Assets.images.wallet.walletWalletblue.path,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Text(context.i18n.wallet_header_ice_wallet),
                  const SizedBox(width: 8),
                  Image.asset(
                    Assets.images.selectArrows.path,
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Button.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    Assets.images.icons.iconFieldSearch.path,
                    width: 24,
                    height: 24,
                  ),
                  type: ButtonType.outlined,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(40, 40),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(40, 40),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Button.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    Assets.images.filter.path,
                    width: 24,
                    height: 24,
                  ),
                  type: ButtonType.outlined,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(40, 40),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(40, 40),
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
