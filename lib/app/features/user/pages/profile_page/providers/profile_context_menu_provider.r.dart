// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user/providers/report_notifier.m.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_user_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_context_menu_provider.r.g.dart';

@riverpod
ProfileContextMenuController profileContextMenuController(Ref ref) {
  return ProfileContextMenuController(ref);
}

class ProfileContextMenuController {
  ProfileContextMenuController(this._ref);
  final Ref _ref;

  void shareProfile(BuildContext context, String pubkey) {
    ShareViaMessageModalRoute(
      eventReference:
          ReplaceableEventReference(masterPubkey: pubkey, kind: UserMetadataEntity.kind).encode(),
    ).push<void>(context);
  }

  void viewBookmarks(BuildContext context) {
    BookmarksRoute().push<void>(context);
  }

  void openSettings(BuildContext context) {
    SettingsRoute().push<void>(context);
  }

  void reportUser(String pubkey) {
    _ref.read(reportNotifierProvider.notifier).report(ReportReason.user(pubkey: pubkey));
  }

  void handleBlockUser(
    BuildContext context, {
    required String masterPubkey,
    required bool isBlocked,
  }) {
    if (!isBlocked) {
      showSimpleBottomSheet<void>(
        context: context,
        child: BlockUserModal(pubkey: masterPubkey),
      );
    } else {
      _ref.read(toggleBlockNotifierProvider.notifier).toggle(masterPubkey);
    }
  }
}
