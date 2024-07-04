import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/horizontal_scroll_menu.dart';
import 'package:ice/generated/assets.gen.dart';

class HasSelection extends StatelessWidget {
  const HasSelection({
    required this.hasSelection,
    super.key,
  });

  final bool hasSelection;

  @override
  Widget build(BuildContext context) {
    return hasSelection
        ? Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.secondaryBackground,
              boxShadow: [
                BoxShadow(
                  color:
                      context.theme.appColors.strokeElements.withOpacity(0.5),
                  offset: Offset(0.0.s, -1.0.s),
                  blurRadius: 5.0.s,
                ),
              ],
            ),
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
          )
        : const HorizontalScrollMenu();
  }
}
