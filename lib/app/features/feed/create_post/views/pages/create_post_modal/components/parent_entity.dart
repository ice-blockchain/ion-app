// SPDX-License-Identifier: ice License 1.0

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/replying_to/replying_to.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';

class ParentEntity extends ConsumerWidget {
  const ParentEntity({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nostrEntity = ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull;
    final userMetadata = ref.watch(userMetadataProvider(eventReference.pubkey)).valueOrNull;

    if (nostrEntity == null || userMetadata == null) {
      return const Skeleton(child: PostSkeleton());
    }

    if (nostrEntity is! PostEntity) {
      return Text('Replying to ${nostrEntity.runtimeType} is not supported yet');
    }

    return Column(
      children: [
        SizedBox(height: 6.0.s),
        ListItem.user(
          title: Text(userMetadata.data.displayName),
          subtitle: Text(prefixUsername(username: userMetadata.data.name, context: context)),
          profilePicture: userMetadata.data.picture,
        ),
        SizedBox(height: 8.0.s),
        Padding(
          padding: EdgeInsets.only(left: 15.0.s),
          child: DottedBorder(
            color: context.theme.appColors.onTerararyFill,
            dashPattern: [5.0.s, 5.0.s],
            customPath: (size) {
              return Path()
                ..moveTo(0, 0)
                ..lineTo(0, size.height);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 22.0.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PostBody(postEntity: nostrEntity),
                  SizedBox(height: 12.0.s),
                  ReplyingTo(name: userMetadata.data.name),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}