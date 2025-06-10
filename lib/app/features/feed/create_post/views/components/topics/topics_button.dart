import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.c.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class TopicsButton extends StatelessWidget {
  const TopicsButton({
    required this.topics,
    required this.feedType,
    super.key,
  });

  final List<FeedInterestsSubcategory> topics;
  final FeedType feedType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SelectTopicsCategoriesRoute(feedType: feedType).push<void>(context);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0.s),
          color: context.theme.appColors.primaryBackground,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.s, horizontal: 6.s),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.svg.walletChannelPrivate.icon(
                color: context.theme.appColors.primaryAccent,
                size: 16.s,
              ),
              SizedBox(width: 2.s),
              Flexible(
                child: Text(
                  topics.isEmpty
                      ? context.i18n.create_post_add_topic
                      : topics.map((topic) => topic.display).join(', '),
                  style: context.theme.appTextThemes.caption2.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                ),
              ),
              SizedBox(width: 2.s),
              Assets.svg.iconArrowRight.icon(
                color: context.theme.appColors.primaryAccent,
                size: 14.s,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
