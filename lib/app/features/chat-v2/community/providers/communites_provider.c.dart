// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat-v2/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'communites_provider.c.g.dart';

///
/// Returns communities the user has joined
///
@riverpod
Future<List<CommunityDefinitionEntity>> communites(Ref ref) async {
  final acceptedJoinEvents = await ref.watch(communityJoinRequestsProvider.future);

  final communities = await Future.wait([
    for (final event in [
      ...(acceptedJoinEvents.accepted),
    ])
      ref.watch(communityMetadataProvider(event.data.uuid).future),
  ]);

  return communities;
}
