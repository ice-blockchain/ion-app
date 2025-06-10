// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/data/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_metadata_provider.c.g.dart';

@riverpod
Future<CommunityDefinitionEntity> communityMetadata(Ref ref, String communityUUID) async {
  final communityEntity =
      await ref.watch(ionConnectNotifierProvider.notifier).requestEntity<CommunityDefinitionEntity>(
            RequestMessage()
              ..addFilter(
                RequestFilter(
                  kinds: const [CommunityDefinitionEntity.kind],
                  tags: {
                    '#h': [communityUUID],
                  },
                ),
              ),
          );

  if (communityEntity == null) {
    throw FailedToFetchCommunityException(communityUUID);
  }

  return communityEntity;
}
