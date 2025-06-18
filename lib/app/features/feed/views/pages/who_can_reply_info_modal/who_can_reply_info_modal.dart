// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.c.dart';
import 'package:ion/app/features/feed/providers/root_post_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class WhoCanReplyInfoModal extends HookConsumerWidget {
  const WhoCanReplyInfoModal({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = useMemoized(
      () => _getDescription(context, ref),
      [context, eventReference],
    );

    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 30.0.s, end: 30.0.s, top: 30.0.s),
            child: InfoCard(
              iconAsset: Assets.svg.actionProfileFollow,
              title: context.i18n.who_can_reply_info_modal_title,
              description: description,
            ),
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }

  String _getDescription(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(rootPostEntityProvider(eventReference: eventReference));
    if (entity == null) {
      return '';
    }

    final whoCanReplySetting = switch (entity) {
      ModifiablePostEntity() => entity.data.whoCanReplySetting,
      ArticleEntity() => entity.data.whoCanReplySetting,
      _ => null,
    };
    if (whoCanReplySetting == null) return '';

    final userMetadata = ref.watch(cachedUserMetadataProvider(eventReference.pubkey));
    String commonDescription() => context.i18n.who_can_reply_info_modal_description(
          userMetadata?.data.displayName ?? '',
          context.i18n.who_can_reply_info_modal_setting(whoCanReplySetting.tagValue),
        );

    return whoCanReplySetting.when(
      everyone: () => '',
      followedAccounts: commonDescription,
      mentionedAccounts: commonDescription,
      accountsWithBadge: (_) => context.i18n.who_can_reply_info_modal_only_verified_description,
    );
  }
}
