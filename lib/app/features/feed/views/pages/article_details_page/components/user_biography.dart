// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/user/user_about/user_about.dart';
import 'package:ion/app/features/components/user/user_info_summary/user_info_summary.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/own_entity_menu.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class UserBiography extends ConsumerWidget {
  const UserBiography({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(eventReference.pubkey));

    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
        border: Border.all(
          width: 1.0.s,
          color: context.theme.appColors.onTerararyFill,
        ),
      ),
      padding: EdgeInsets.all(
        12.0.s,
      ),
      child: Column(
        children: [
          UserInfo(
            pubkey: eventReference.pubkey,
            trailing: isOwnedByCurrentUser
                ? OwnEntityMenu(eventReference: eventReference, onDelete: context.pop)
                : UserInfoMenu(pubkey: eventReference.pubkey),
          ),
          SizedBox(height: 12.0.s),
          UserAbout(pubkey: eventReference.pubkey, padding: EdgeInsets.only(bottom: 12.0.s)),
          UserInfoSummary(pubkey: eventReference.pubkey),
        ],
      ),
    );
  }
}
