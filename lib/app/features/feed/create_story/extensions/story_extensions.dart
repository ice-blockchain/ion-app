// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/data/models/story_viewer_state.dart';

extension StoryViewerStateX on StoryViewerState {
  bool get hasNextStory =>
      whenOrNull(
        ready: (users, userIndex, storyIndex) => storyIndex < users[userIndex].stories.length - 1,
      ) ??
      false;

  bool get hasPreviousStory =>
      whenOrNull(
        ready: (_, __, storyIndex) => storyIndex > 0,
      ) ??
      false;

  bool get hasNextUser =>
      whenOrNull(
        ready: (users, userIndex, _) => userIndex < users.length - 1,
      ) ??
      false;

  bool get hasPreviousUser =>
      whenOrNull(
        ready: (_, userIndex, __) => userIndex > 0,
      ) ??
      false;

  Story? get currentStory => whenOrNull(
        ready: (users, userIndex, storyIndex) => users[userIndex].stories[storyIndex],
      );

  UserStories? get currentUser => whenOrNull(
        ready: (users, userIndex, _) => users[userIndex],
      );
}

extension UserStoriesX on UserStories {
  Story? getStoryById(String id) => stories.firstWhereOrNull((story) => story.data.id == id);

  int getStoryIndex(String id) => stories.indexWhere((story) => story.data.id == id);

  bool hasStoryWithId(String id) => stories.any((story) => story.data.id == id);
}

extension UserStoriesListX on List<UserStories> {
  UserStories? findByUserId(String userId) => firstWhereOrNull((user) => user.userId == userId);

  bool hasUserId(String userId) => any((user) => user.userId == userId);
}

extension StoryX on Story {
  String get authorId => data.authorId;
  String get imageUrl => data.imageUrl;
}
