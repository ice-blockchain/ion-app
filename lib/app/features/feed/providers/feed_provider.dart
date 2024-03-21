import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_provider.g.dart';

@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  List<PostData> build() {
    return List<PostData>.unmodifiable(<PostData>[]);
  }

  Future<void> fetchPosts() async {
    final NostrRelay relay =
        await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
    final RequestMessage requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: <int>[1], limit: 20));
    final List<EventMessage> events =
        await requestEvents(requestMessage, relay);
    state = events
        .map(
          (EventMessage event) => PostData(id: event.id, body: event.content),
        )
        .toList();
  }
}
