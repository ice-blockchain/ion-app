import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/shadow/shadow_container/shadow_container.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/share_options_menu.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareBottomActions extends StatelessWidget {
  const ShareBottomActions({
    required this.hasSelectedUsers,
    super.key,
  });

  final bool hasSelectedUsers;

  @override
  Widget build(BuildContext context) {
    return hasSelectedUsers
        ? CustomBoxShadow(
            child: ColoredBox(
              color: context.theme.appColors.secondaryBackground,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 27.0.s,
                  left: 44.0.s,
                  right: 44.0.s,
                  bottom: 33.5.s,
                ),
                child: Button.compact(
                  mainAxisSize: MainAxisSize.max,
                  minimumSize: Size(56.0.s, 56.0.s),
                  trailingIcon: Assets.images.icons.iconButtonNext
                      .icon(color: context.theme.appColors.onPrimaryAccent),
                  label: Text(
                    context.i18n.feed_send,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          )
        : const ShareOptionsMenu();
  }
}
