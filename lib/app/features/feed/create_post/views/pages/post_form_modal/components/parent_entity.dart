// SPDX-License-Identifier: ice License 1.0

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/badges_user_list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.r.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/replying_to/replying_to.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/utils/username.dart';

class ParentEntity extends ConsumerWidget {
  const ParentEntity({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentEntity =
        ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));
    final userMetadata = ref.watch(userMetadataProvider(eventReference.masterPubkey)).valueOrNull;

    if (parentEntity == null || userMetadata == null) {
      return const Skeleton(child: PostSkeleton());
    }

    return Column(
      children: [
        SizedBox(height: 6.0.s),
        BadgesUserListItem(
          title: Text(userMetadata.data.displayName),
          subtitle: Text(prefixUsername(username: userMetadata.data.name, context: context)),
          pubkey: userMetadata.masterPubkey,
          trailing: UserInfoMenu(
            eventReference: eventReference,
          ),
        ),
        SizedBox(height: 8.0.s),
        ParentDottedLine(
          padding: EdgeInsetsDirectional.only(
            start: 15.0.s,
            end: 22.0.s,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              switch (parentEntity) {
                PostEntity() || ModifiablePostEntity() => PostBody(
                    entity: parentEntity,
                    sidePadding: 0,
                  ),
                ArticleEntity() =>
                  Article(eventReference: eventReference, header: const SizedBox.shrink()),
                _ => const SizedBox.shrink(),
              },
              SizedBox(height: 12.0.s),
              ReplyingTo(name: userMetadata.data.name),
              SizedBox(height: 16.0.s),
            ],
          ),
        ),
        SizedBox(height: 8.0.s),
      ],
    );
  }
}

class ParentDottedLine extends StatelessWidget {
  const ParentDottedLine({
    required this.child,
    this.padding,
    this.visible = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsDirectional? padding;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: padding?.start ?? 0,
        top: padding?.top ?? 0,
        bottom: padding?.bottom ?? 0,
      ),
      child: DottedBorder(
        color: context.theme.appColors.onTertiaryFill,
        dashPattern: [5.0.s, 5.0.s],
        padding: EdgeInsetsDirectional.only(start: padding?.end ?? 0.0)
            .resolve(Directionality.of(context)),
        customPath: (size) {
          return Path()
            ..moveTo(0, 0)
            ..lineTo(0, size.height);
        },
        child: child,
      ),
    );
  }
}
