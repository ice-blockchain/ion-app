import 'dart:math';

import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_store_provider.g.dart';

typedef State = Map<String, PostData>;

//TODO??
@Riverpod(keepAlive: true)
class PostsStore extends _$PostsStore {
  @override
  State build() {
    return Map.unmodifiable({});
  }

  void storePosts(List<PostData> posts) {
    state = Map.unmodifiable({...state, for (final post in posts) post.id: post});
  }

  void storePost(PostData post) {
    state = Map.unmodifiable({...state, post.id: post});
  }
}

@riverpod
Future<PostData?> postById(PostByIdRef ref, {required String id}) async {
  final posts = ref.watch(postsStoreProvider);
  return posts[id];
}

PostData generateFakePost() {
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
