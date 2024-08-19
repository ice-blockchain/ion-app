import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_separator.dart';
import 'package:ice/app/features/wallet/model/feed_type.dart';

class FeedModalItem extends StatelessWidget {
  const FeedModalItem({
    required this.feedType,
    required this.onTap,
    super.key,
  });

  final FeedType feedType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenSideOffset.small(
          child: Padding(
            padding: EdgeInsets.only(top: 2.0.s, bottom: 1.0.s),
            child: ListItem(
              title: Text(
                feedType.getDisplayName(context),
                style: context.theme.appTextThemes.subtitle2.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              subtitle: Text(
                feedType.getDescription(context),
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: 12.0.s),
                child: Container(
                  width: 42.0.s,
                  height: 42.0.s,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: feedType.getIconColor(context),
                  ),
                  child: Center(
                    child: feedType.iconAsset.icon(size: 24.0.s, color: Colors.white),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              onTap: onTap,
            ),
          ),
        ),
        const FeedModalSeparator(),
      ],
    );
  }
}
