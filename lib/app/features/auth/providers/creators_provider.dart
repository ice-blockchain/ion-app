import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'creators_provider.g.dart';

@riverpod
class Creators extends _$Creators {
  @override
  List<String> build() {
    return [];
  }

  Future<void> fetchCreators() async {
    final requestMessage = RequestMessage()
      ..addFilter(
        const RequestFilter(
          kinds: [UserMetadata.kind, UserRelays.kind],
          search: 'discover content creators to follow',
          limit: 20,
        ),
      );
    final eventsStream = ref.read(nostrNotifierProvider.notifier).request(requestMessage);
    await for (final event in eventsStream) {
      final userMetadata = UserMetadata.fromEventMessage(event);
      ref.read(nostrCacheProvider.notifier).cache(userMetadata);
      state = [...state, userMetadata.pubkey];
    }
  }
}
