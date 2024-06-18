import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';
import 'package:ice/generated/assets.gen.dart';

class NetworkButton extends StatelessWidget {
  const NetworkButton({
    super.key,
    required this.onTap,
    required this.networkType,
  });

  final VoidCallback onTap;
  final NetworkType networkType;

  @override
  Widget build(BuildContext context) {
    final AppColorsExtension colors = context.theme.appColors;
    final AppTextThemesExtension textTheme = context.theme.appTextThemes;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.strokeElements),
        borderRadius: BorderRadius.circular(16.0.s),
        color: colors.secondaryBackground,
      ),
      child: ListItem(
        contentPadding: EdgeInsets.only(
          left: ScreenSideOffset.defaultSmallMargin,
          right: 8.0.s,
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
            SizedBox(height: 4.0.s),
            Row(
              children: <Widget>[
                networkType.iconAsset.icon(),
                SizedBox(width: 10.0.s),
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
          padding: EdgeInsets.all(8.0.s),
          child: Assets.images.icons.iconArrowDown.icon(),
        ),
      ),
    );
  }
}
