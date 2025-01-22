import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/join_community_data.c.dart';
import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'communites_provider.c.g.dart';

@riverpod
Future<List<CommunityDefinitionData>> communites(Ref ref) async {
  final acceptedJoinEvents = ref.watch(communityJoinRequestsNotifierProvider).valueOrNull;

  final communities = <CommunityDefinitionData>[];
  for (final event in [
    ...(acceptedJoinEvents?.accepted ?? <JoinCommunityEntity>[]),
    ...(acceptedJoinEvents?.waitingApproval ?? <JoinCommunityEntity>[]),
  ]) {
    final communityDefinition = await ref.watch(communityMetadataProvider(event.data.uuid).future);
    communities.add(communityDefinition);
  }

  return communities;
}
