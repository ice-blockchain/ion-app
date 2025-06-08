// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/community/data/models/entities/community_join_data.c.dart';

part 'community_join_requests_state.c.freezed.dart';

@freezed
class CommunityJoinRequestsState with _$CommunityJoinRequestsState {
  const factory CommunityJoinRequestsState({
    required List<CommunityJoinEntity> accepted,
    required List<CommunityJoinEntity> waitingApproval,
  }) = _CommunityJoinRequestsState;
}
