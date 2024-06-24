import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/generated/assets.gen.dart';

class NetworkButton extends StatelessWidget {
  const NetworkButton({
    required this.onTap,
    required this.networkType,
    super.key,
  });

  final VoidCallback onTap;
  final NetworkType networkType;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.strokeElements),
        borderRadius: BorderRadius.circular(UiSize.medium),
        color: colors.secondaryBackground,
      ),
      child: ListItem(
        contentPadding: EdgeInsets.only(
          left: ScreenSideOffset.defaultSmallMargin,
          right: UiSize.xxSmall,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.i18n.wallet_network,
              style: textTheme.caption3.copyWith(
                color: colors.secondaryText,
              ),
            ),
            SizedBox(height: UiSize.xxxSmall),
            Row(
              children: <Widget>[
                networkType.iconAsset.icon(),
                SizedBox(width: UiSize.xSmall),
                Expanded(
                  child: Text(
                    networkType.getDisplayName(context),
                    style: textTheme.body,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        onTap: onTap,
        trailing: Padding(
          padding: EdgeInsets.all(UiSize.xxSmall),
          child: Assets.images.icons.iconArrowDown.icon(),
        ),
      ),
    );
  }
}
