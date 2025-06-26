// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.f.dart';

part 'community_join_requests_state.f.freezed.dart';

@freezed
class CommunityJoinRequestsState with _$CommunityJoinRequestsState {
  const factory CommunityJoinRequestsState({
    required List<CommunityJoinEntity> accepted,
    required List<CommunityJoinEntity> waitingApproval,
  }) = _CommunityJoinRequestsState;
}
