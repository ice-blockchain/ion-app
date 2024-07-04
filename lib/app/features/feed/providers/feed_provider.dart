import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_provider.g.dart';

@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  AsyncValue<List<PostData>> build() {
    return const AsyncLoading<List<PostData>>();
  }

  Future<void> fetchPosts() async {
    state = const AsyncLoading<List<PostData>>().copyWithPrevious(state);
    final relay =
        await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: <int>[1], limit: 20));
    final events = await requestEvents(requestMessage, relay);
    state = AsyncData<List<PostData>>(
      events.map(PostData.fromEventMessage).toList(),
    );
  }
}
