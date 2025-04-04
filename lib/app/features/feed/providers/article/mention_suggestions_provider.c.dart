// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mention_suggestions_provider.c.g.dart';

@riverpod
Future<List<String>> mentionSuggestions(Ref ref, String query) async {
  if (query.isEmpty || !query.startsWith('@')) {
    return [];
  }

  final searchQuery = query.substring(1).toLowerCase();

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [UserMetadataEntity.kind],
        search: SearchExtensions(
          [
            QuerySearchExtension(searchQuery: searchQuery),
            DiscoveryCreatorsSearchExtension(),
            MentionsSearchExtension(),
          ],
        ).toString(),
        limit: 10,
      ),
    );
  final ionConnect = ref.read(ionConnectNotifierProvider.notifier);

  final pubKeys = <String>{};

  await for (final entity in ionConnect.requestEntities(requestMessage)) {
    pubKeys.add(entity.pubkey);
  }

  return pubKeys.toList();
}
