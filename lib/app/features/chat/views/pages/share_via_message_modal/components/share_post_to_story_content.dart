import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class SharePostToStoryContent extends StatelessWidget {
  const SharePostToStoryContent({
    required this.eventReference,
    required this.postItselfEntity,
    super.key,
  });

  final EventReference eventReference;
  final ModifiablePostEntity postItselfEntity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: Container(
        height: 600.0.s,
        padding: EdgeInsets.symmetric(horizontal: 20.0.s, vertical: 42.0.s),
        color: context.theme.appColors.attentionBlock,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0.s),
          child: Material(
            color: context.theme.appColors.secondaryBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 12.0.s),
                  child: Post(
                    eventReference: eventReference,
                    footer: const SizedBox.shrink(),
                    topOffset: 0,
                    header: UserInfo(
                      pubkey: eventReference.pubkey,
                      createdAt: postItselfEntity.data.publishedAt.value,
                      trailing: const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
