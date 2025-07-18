// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/components/counter_items_footer/reposts_counter_button.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';

import '../../../../../../helpers/robot_test_harness.dart';
import '../../../helpers/repost_test_helpers.dart';

void main() {
  group('RepostsCounterButton', () {
    const eventReference = RepostTestConstants.eventReference;

    testWidgets('shows counter value when reposts count is available', (tester) async {
      final postRepost = PostRepostFactory.createNotReposted(
        repostsCount: 5,
        quotesCount: 3,
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('shows empty string when reposts count is null', (tester) async {
      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(null),
          ),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('0'), findsNothing);
      expect(find.textContaining(RegExp(r'\d')), findsNothing);
    });

    testWidgets('shows active state when reposted by me', (tester) async {
      final postRepost = PostRepostFactory.createReposted(
        repostsCount: 2,
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
      );

      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('updates when reposts count changes', (tester) async {
      final streamController = StreamController<PostRepost?>();

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => streamController.stream,
          ),
        ],
      );

      streamController.add(null);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);

      streamController.add(PostRepostFactory.createNotReposted(repostsCount: 1));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      streamController.add(PostRepostFactory.createReposted(repostsCount: 2));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      await streamController.close();
    });

    testWidgets('formats large numbers correctly', (tester) async {
      final postRepost = PostRepostFactory.createWithHighCounters(
        quotesCount: 0,
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('1'), findsOneWidget);
    });

    testWidgets('shows loading state when stream has not emitted yet', (tester) async {
      const neverStream = Stream<PostRepost?>.empty();

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => neverStream,
          ),
        ],
      );

      expect(find.textContaining(RegExp(r'\d')), findsNothing);
    });

    testWidgets('shows count from initial async load', (tester) async {
      final futureStream = Stream<PostRepost?>.fromFuture(
        Future.delayed(
          const Duration(milliseconds: 100),
          () => PostRepostFactory.createNotReposted(
            repostsCount: 10,
            quotesCount: 5,
          ),
        ),
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => futureStream,
          ),
        ],
      );

      expect(find.textContaining(RegExp(r'\d')), findsNothing);

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('handles post without cache data', (tester) async {
      final postRepost = PostRepostFactory.createNotReposted();

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('0'), findsNothing);
      expect(find.textContaining(RegExp(r'\d')), findsNothing);
      expect(find.byType(RepostsCounterButton), findsOneWidget);
    });

    testWidgets('transitions from no cache to having cache data after repost', (tester) async {
      final streamController = StreamController<PostRepost?>();

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => streamController.stream,
          ),
        ],
      );

      streamController.add(PostRepostFactory.createNotReposted());
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);
      expect(find.textContaining(RegExp(r'\d')), findsNothing);

      streamController.add(PostRepostFactory.createReposted());
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      await streamController.close();
    });
  });
}
