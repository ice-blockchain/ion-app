// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/mute_set.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'muted_conversations_provider.c.g.dart';

@riverpod
class MutedConversations extends _$MutedConversations {
  @override
  FutureOr<MuteSetEntity?> build() async {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [MuteSetEntity.kind],
          tags: {
            '#d': [MuteSetType.chatConversations.dTagName],
          },
        ),
      );

    final mutedConversationsEntity =
        await ref.read(ionConnectNotifierProvider.notifier).requestEntity<MuteSetEntity>(
              requestMessage,
            );

    return mutedConversationsEntity;
  }

  Future<void> toggleMutedMasterPubkey(String masterPubkey) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final existingMutedMasterPubkeys = state.value?.data.masterPubkeys ?? [];

      final newMutedMasterPubkeys = existingMutedMasterPubkeys.contains(masterPubkey)
          ? existingMutedMasterPubkeys.where((p) => p != masterPubkey).toList()
          : [...existingMutedMasterPubkeys, masterPubkey];

      final MuteSetData muteSetData;
      if (state.value != null) {
        muteSetData = state.value!.data.copyWith(masterPubkeys: newMutedMasterPubkeys);
      } else {
        muteSetData = MuteSetData(
          type: MuteSetType.chatConversations,
          masterPubkeys: newMutedMasterPubkeys,
        );
      }

      final muteSetEntity =
          await ref.read(ionConnectNotifierProvider.notifier).sendEntityData<MuteSetEntity>(
                muteSetData,
              );

      return muteSetEntity;
    });
  }
}

@riverpod
Future<List<String>> mutedConversationIds(Ref ref) async {
  final mutedConversations = await ref.watch(mutedConversationsProvider.future);
  final mutedCommunityIds = mutedConversations?.data.communitiesIds ?? [];

  final mutedReceiverPubkeys = mutedConversations?.data.masterPubkeys ?? [];
  final e2eeChatMessageService = ref.watch(sendE2eeChatMessageServiceProvider);
  final mutedOneToOneConversationIds = [
    ...mutedReceiverPubkeys
        .map((pubkey) => e2eeChatMessageService.generateConversationId(receiverPubkey: pubkey)),
  ];

  return [
    ...mutedOneToOneConversationIds,
    ...mutedCommunityIds,
  ];
}
