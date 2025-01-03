// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_admins_provider.c.g.dart';

@riverpod
class ChannelAdmins extends _$ChannelAdmins {
  @override
  Map<String, ChannelAdminType> build({Map<String, ChannelAdminType>? initialAdmins}) {
    if (initialAdmins != null) {
      return Map<String, ChannelAdminType>.unmodifiable(initialAdmins);
    } else {
      final currentPubkey = ref.read(currentPubkeySelectorProvider).valueOrNull;
      final result = <String, ChannelAdminType>{};
      if (currentPubkey != null) {
        result.putIfAbsent(currentPubkey, () => ChannelAdminType.owner);
      }
      return Map<String, ChannelAdminType>.unmodifiable(result);
    }
  }

  void setAdmin(String pubkey, ChannelAdminType type) {
    final newState = Map<String, ChannelAdminType>.from(state);
    newState[pubkey] = type;
    state = Map<String, ChannelAdminType>.unmodifiable(newState);
  }

  void deleteAdmin(String pubkey) {
    state = Map<String, ChannelAdminType>.unmodifiable(
      Map<String, ChannelAdminType>.from(state)..remove(pubkey),
    );
  }
}
