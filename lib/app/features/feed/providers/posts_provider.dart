import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_provider.freezed.dart';
part 'posts_provider.g.dart';

@Freezed(copyWith: true)
class PostsState with _$PostsState {
  const factory PostsState({
    required Map<String, PostData> store,
    required Map<FeedCategory, List<String>> categoryPostIds,
    required Map<String, List<String>> postReplyIds,
  }) = _PostsState;
}

//TODO:change to PostsStore and remove categoryPostIds from here
@riverpod
class Posts extends _$Posts {
  @override
  PostsState build() {
    return const PostsState(store: {}, categoryPostIds: {}, postReplyIds: {});
  }

  Future<void> fetchCategoryPosts({required FeedCategory category}) async {
    final relay = await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: <int>[1], limit: 20));
    final events = await requestEvents(requestMessage, relay);

    final posts = events.map(PostData.fromEventMessage).toList();

    state = state.copyWith(
      store: {...state.store, for (final post in posts) post.id: post},
      categoryPostIds: {...state.categoryPostIds, category: posts.map((post) => post.id).toList()},
    );
  }

  Future<void> fetchPostReplies({required String postId}) async {
    if (state.postReplyIds[postId] != null) {
      return;
    }

    final posts = List.generate(Random().nextInt(10) + 1, (_) => _generateFakePost());
    state = state.copyWith(
      store: {...state.store, for (final post in posts) post.id: post},
      postReplyIds: {...state.postReplyIds, postId: posts.map((post) => post.id).toList()},
    );
  }
}

@riverpod
PostData? postByIdSelector(PostByIdSelectorRef ref, {required String postId}) {
  return ref.watch(postsProvider.select((state) => state.store[postId]));
}

@riverpod
List<String> categoryPostIdsSelector(CategoryPostIdsSelectorRef ref,
    {required FeedCategory category}) {
  return ref.watch(postsProvider.select((state) => state.categoryPostIds[category] ?? []));
}

@riverpod
List<String> postReplyIdsSelector(PostReplyIdsSelectorRef ref, {required String postId}) {
  return ref.watch(postsProvider.select((state) => state.postReplyIds[postId] ?? []));
}

PostData _generateFakePost() {
  var random = Random.secure();
  final post = PostData.fromRawContent(
    id: random.nextInt(10000000).toString(),
    rawContent: _fakeFeedMessages.elementAt(random.nextInt(_fakeFeedMessages.length)),
  );
  return post;
}

const _fakeFeedMessages = [
  "New album drop! Listen now.",
  "Check out this hidden gem!",
  "Just booked my dream vacation!",
  "Coffee first, then conquer.",
  "Surprise! Giveaway alert.",
  "Summer vibes in full swing.",
  "Caught the perfect sunset today.",
  "Unboxing something exciting!",
  "Weekend plans: relax and recharge.",
  "Big news coming soon!",
  "Just finished a great book!",
  "New recipe tried, success!",
  "Morning run: check.",
  "Exploring new horizons today.",
  "Can't wait for the weekend!",
  "Finally tried that new café.",
  "Fresh starts are the best.",
  "Another day, another adventure.",
  "Game night was a blast!",
  "Feeling grateful for today.",
  "Sunshine and good vibes.",
  "Finally found the perfect outfit!",
  "Late-night thoughts: deep and meaningful.",
  "New hobby: officially obsessed.",
  "Daily dose of motivation!",
  "Just wrapped up a project.",
  "Throwback to simpler times.",
  "Brunch with the besties!",
  "Late-night movie marathon.",
  "Outdoor adventures await.",
  "Small wins add up!",
  "Starting the day with positivity.",
  "Dream big, work hard.",
  "Caught up on sleep!",
  "Early bird gets the worm.",
  "New day, new opportunities.",
  "Self-care Sunday essentials.",
  "Feeling accomplished today!",
  "Tackling my to-do list.",
  "Trying something new today.",
  "Found my new favorite place!",
  "Sunday strolls are the best.",
  "Chasing dreams, one step at a time.",
  "Cheers to good friends!",
  "Finished a tough workout!",
  "Big things in the works.",
  "Taking it one day at a time.",
  "Ready to take on the world!",
  "Another milestone achieved.",
  "Celebrating small victories today.",
  "New day, new challenges.",
  "On the hunt for inspiration.",
  "Finally caught up on emails!",
  "Living my best life.",
  "Weekend getaway, here I come!",
  "Spontaneous road trip!",
  "Found a new favorite spot.",
  "Ready for a fresh start.",
  "Weekend vibes are strong.",
  "Excited for what’s next.",
  "Embracing change today.",
  "Big plans for the future.",
  "Just finished a creative project!",
  "Found a new hobby!",
  "Taking a break to recharge.",
  "Loving this new playlist!",
  "Feeling inspired today.",
  "Another chapter closed.",
  "Soaking up the last days of summer.",
  "Back to the grind.",
  "Feeling refreshed and recharged.",
  "New beginnings, fresh perspectives.",
  "Counting down to the weekend!",
  "Finally got my dream job!",
  "Monday motivation in full effect.",
  "Trying out a new recipe.",
  "Mid-week pick-me-up.",
  "Feeling blessed today.",
  "Ready for new adventures.",
  "Enjoying some quiet time.",
  "Weekend goals: accomplished!",
  "Caught up with an old friend.",
  "Big dreams, bigger goals.",
  "New opportunities on the horizon.",
  "Another day, another lesson.",
  "Grateful for the little things.",
  "Exploring new creative outlets.",
  "Just completed a major task!",
  "Making the most of today.",
  "Finally visited that place!",
  "Another day, another chance.",
  "Good vibes only.",
  "Feeling unstoppable today.",
  "Challenging myself daily.",
  "Reflecting on the past week.",
  "Taking it one step at a time.",
  "New discoveries every day.",
  "Motivation Monday, let’s go!",
  "Made it to the weekend!",
  "Feeling content with life.",
  "Fresh air and good company.",
  "Grateful for another day."
];
