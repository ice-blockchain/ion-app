import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/constants/ui_size.dart';
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
      children: <Widget>[
        ListItem(
          title: Text(feedType.getDisplayName(context)),
          subtitle: Text(feedType.getDescription(context)),
          leading: Container(
            width: 42.0.s,
            height: 42.0.s,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: feedType.getIconColor(context),
            ),
            child: Center(
              child: feedType.iconAsset
                  .icon(size: UiSize.sLarge, color: Colors.white),
            ),
          ),
          backgroundColor: Colors.transparent,
          onTap: onTap,
        ),
        const FeedModalSeparator(),
      ],
    );
  }
}
