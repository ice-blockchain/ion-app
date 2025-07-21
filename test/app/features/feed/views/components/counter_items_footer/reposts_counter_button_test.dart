// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/components/counter_items_footer/reposts_counter_button.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../../../../helpers/robot_test_harness.dart';
import '../../../helpers/repost_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });
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

    testWidgets('shows 0 when reposts count is null', (tester) async {
      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(null),
          ),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
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
      expect(find.text('0'), findsOneWidget);

      streamController.add(PostRepostFactory.createNotReposted(repostsCount: 1));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      streamController.add(PostRepostFactory.createReposted(repostsCount: 2));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      await streamController.close();
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

      expect(find.text('0'), findsOneWidget);
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

      expect(find.text('0'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
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

      streamController.add(null);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      streamController.add(PostRepostFactory.createReposted());
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      await streamController.close();
    });

    testWidgets('shows 0 when both reposts and quotes are zero', (tester) async {
      final postRepost = PostRepostFactory.create();

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostsCounterButton(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
    });
  });
}
