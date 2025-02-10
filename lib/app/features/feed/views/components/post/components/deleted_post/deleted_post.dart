import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class DeletedPost extends StatelessWidget {
  const DeletedPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0.s, bottom: 22.0.s),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.s),
          color: context.theme.appColors.tertararyBackground,
          border: Border.all(color: context.theme.appColors.onTerararyFill, width: 1.0.s),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 12.0.s, right: 16.0.s, bottom: 12.0.s, left: 12.0.s),
          child: Row(
            children: [
              Assets.svg.iconFeedDeletedpost
                  .icon(size: 20.0.s, color: context.theme.appColors.quaternaryText),
              SizedBox(width: 8.0.s),
              Text(
                context.i18n.feed_post_deleted,
                style: context.theme.appTextThemes.caption
                    .copyWith(color: context.theme.appColors.quaternaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
