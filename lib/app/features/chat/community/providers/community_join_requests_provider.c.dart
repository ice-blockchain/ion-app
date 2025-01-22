import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/join_community_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_join_requests_provider.c.freezed.dart';
part 'community_join_requests_provider.c.g.dart';

@riverpod
class CommunityJoinRequestsNotifier extends _$CommunityJoinRequestsNotifier {
  @override
  FutureOr<CommunitiesState> build() async {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final requestMessage = RequestMessage(
      filters: [
        RequestFilter(
          kinds: const [JoinCommunityEntity.kind],
          tags: {
            '#p': [currentPubkey],
          },
        ),
      ],
    );

    final eventsStream =
        ref.watch(ionConnectNotifierProvider.notifier).requestEntities(requestMessage);

    final accepted = <JoinCommunityEntity>[];
    final waitingApproval = <JoinCommunityEntity>[];

    await for (final entity in eventsStream) {
      if (entity is JoinCommunityEntity) {
        if (entity.data.pubkey == currentPubkey && entity.masterPubkey == currentPubkey) {
          accepted.add(entity);
        } else {
          if (entity.data.expiration != null && entity.data.expiration!.isAfter(DateTime.now())) {
            waitingApproval.add(entity);
          }
        }
      }
    }

    return CommunitiesState(accepted: accepted, waitingApproval: waitingApproval);
  }
}

@freezed
class CommunitiesState with _$CommunitiesState {
  const factory CommunitiesState({
    required List<JoinCommunityEntity> accepted,
    required List<JoinCommunityEntity> waitingApproval,
  }) = _CommunitiesState;
}
