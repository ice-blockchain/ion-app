// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_privacy_provider.r.g.dart';

@riverpod
Future<bool> canSendMessage(Ref ref, String masterPubkey) async {
  final currentUserIsFollowed = isCurrentUserFollowed(ref, masterPubkey, cache: false);

  final userPrivacySettings = await ref.watch(
    userMetadataProvider(masterPubkey, cache: false).future,
  );
  final everyoneCanSend = userPrivacySettings?.data.whoCanMessageYou == null;

  return everyoneCanSend || currentUserIsFollowed;
}
