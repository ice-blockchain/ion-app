// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mention_suggestions_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> mentionSuggestions(Ref ref, String query) async {
  if (query.isEmpty || !query.startsWith('@')) {
    return [];
  }
  await ref.debounce();

  final searchQuery = query.substring(1).toLowerCase();

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [UserMetadataEntity.kind],
        search: searchQuery,
        limit: 10,
      ),
    );
  final nostr = ref.read(nostrNotifierProvider.notifier);

  final pubKeys = <String>{};

  await for (final entity in nostr.requestEntities(requestMessage)) {
    pubKeys.add(entity.pubkey);
  }

  return pubKeys.toList();
}
