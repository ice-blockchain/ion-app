// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';

Future<void> pumpWithOverrides(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      observers: observers,
      child: MaterialApp(home: child),
    ),
  );

  await tester.pump();
}

List<Override> storyViewerOverrides(ModifiablePostEntity post) {
  final stories = UserStories(pubkey: 'alice', stories: [post]);
  return [
    storiesProvider.overrideWith((_) => [stories]),
    filteredStoriesByPubkeyProvider('alice').overrideWith((_) => [stories]),
  ];
}
