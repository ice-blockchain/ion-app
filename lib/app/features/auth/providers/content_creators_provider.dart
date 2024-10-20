// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_creators_provider.g.dart';

@riverpod
class ContentCreators extends _$ContentCreators {
  @override
  List<String> build() {
    return [];
  }

  Future<void> fetchCreators() async {
    final requestMessage = RequestMessage()
      ..addFilter(
        const RequestFilter(
          kinds: [UserMetadata.kind, UserRelays.kind],
          //TODO: uncomment when our relays are used
          // search: DiscoveryCreatorsSearchExtension().toString(),
          limit: 40,
        ),
      );
    final eventsStream = ref
        .read(nostrNotifierProvider.notifier)
        .request(requestMessage, actionSource: const ActionSourceIndexers());
    await for (final event in eventsStream) {
      if (event.kind == UserMetadata.kind) {
        final userMetadata = UserMetadata.fromEventMessage(event);
        ref.read(nostrCacheProvider.notifier).cache(userMetadata);
        state = [...state, userMetadata.pubkey];
      } else if (event.kind == UserRelays.kind) {
        final userRelays = UserRelays.fromEventMessage(event);
        ref.read(nostrCacheProvider.notifier).cache(userRelays);
      }
    }
  }
}
