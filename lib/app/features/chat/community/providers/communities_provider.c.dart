import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/join_community_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'communities_provider.c.g.dart';

@riverpod
class CommunitiesNotifier extends _$CommunitiesNotifier {
  @override
  FutureOr<List<String>> build() async {
    final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);
    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final requestMessage = RequestMessage(
      filters: [
        RequestFilter(
          kinds: const [CommunityDefinitionEntity.kind],
          authors: [currentPubkey],
        ),
      ],
    );
    final eventsStream = ref.watch(ionConnectNotifierProvider.notifier).requestEntities(
          requestMessage,
        );

    final communities = <String>{};

    await for (final entity in eventsStream) {
      if (entity is CommunityDefinitionEntity) {
        communities.add(entity.data.uuid);
      }
    }

    return communities.toList();
  }

  Future<void> joinCommunity(String communityId, String pubkey) async {
    final joinCommunityData = JoinCommunityData(
      uuid: communityId,
      pubkey: pubkey,
    );

    final result =
        await ref.watch(ionConnectNotifierProvider.notifier).sendEntityData(joinCommunityData);

    if (result is JoinCommunityEntity) {
      ref.invalidateSelf();
      return;
    }

    throw FailedToJoinCommunityException();
  }
}
