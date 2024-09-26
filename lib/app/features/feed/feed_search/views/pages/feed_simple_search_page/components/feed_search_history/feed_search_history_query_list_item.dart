import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchHistoryQueryListItem extends ConsumerWidget {
  const FeedSearchHistoryQueryListItem({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FeedSimpleSearchRoute(query: query).replace(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.s,
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              query,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            Assets.svg.iconSearchHistorylink.icon(size: 20.0.s),
          ],
        ),
      ),
    );
  }
}
