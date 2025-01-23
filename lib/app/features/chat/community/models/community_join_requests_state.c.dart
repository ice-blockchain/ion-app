import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/community/models/entities/join_community_data.c.dart';

part 'community_join_requests_state.c.freezed.dart';

@freezed
class CommunityJoinRequestsState with _$CommunityJoinRequestsState {
  const factory CommunityJoinRequestsState({
    required List<JoinCommunityEntity> accepted,
    required List<JoinCommunityEntity> waitingApproval,
  }) = _CommunityJoinRequestsState;
}
