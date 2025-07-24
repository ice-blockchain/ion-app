// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/components/modal_action_button/modal_action_button.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:ion/app/features/feed/views/pages/repost_options_modal/repost_options_modal.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../../../../helpers/robot_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  group('RepostOptionsModal Quote Action Tests', () {
    const eventReference = ImmutableEventReference(
      masterPubkey: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
      eventId: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
      kind: 1,
    );

    testWidgets('shows Quote button regardless of repost state', (tester) async {
      // Test with not reposted
      var postRepost = const PostRepost(
        eventReference: eventReference,
        repostsCount: 5,
        quotesCount: 3,
        repostedByMe: false,
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostOptionsModal(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,
      );

      await tester.pumpAndSettle();

      // Find quote button
      expect(find.text('Quote'), findsOneWidget);
      expect(find.byType(ModalActionButton), findsNWidgets(2));

      // Test with reposted
      postRepost = postRepost.copyWith(
        repostedByMe: true,
        myRepostReference: const ReplaceableEventReference(
          kind: 16,
          masterPubkey: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
          dTag: 'testTag',
        ),
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostOptionsModal(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,
      );

      await tester.pumpAndSettle();

      // Quote button should still be there
      expect(find.text('Quote'), findsOneWidget);
      expect(find.byType(ModalActionButton), findsNWidgets(2));
    });

    testWidgets('modal updates when quote count changes', (tester) async {
      final streamController = StreamController<PostRepost?>();

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostOptionsModal(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => streamController.stream,
          ),
        ],
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,
      );

      // Initial state
      streamController.add(
        const PostRepost(
          eventReference: eventReference,
          repostsCount: 5,
          quotesCount: 3,
          repostedByMe: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quote'), findsOneWidget);

      streamController.add(
        const PostRepost(
          eventReference: eventReference,
          repostsCount: 5,
          quotesCount: 4,
          repostedByMe: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quote'), findsOneWidget);

      await streamController.close();
    });

    testWidgets('combined repost and quote state displays correctly', (tester) async {
      const postRepost = PostRepost(
        eventReference: eventReference,
        repostsCount: 10,
        quotesCount: 5,
        repostedByMe: true,
        myRepostReference: ReplaceableEventReference(
          kind: 16,
          masterPubkey: 'testPubkey',
          dTag: 'testTag',
        ),
      );

      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostOptionsModal(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(postRepost),
          ),
        ],
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,
      );

      await tester.pumpAndSettle();

      expect(find.text('Undo repost'), findsOneWidget);
      expect(find.text('Quote'), findsOneWidget);
      expect(find.text('Repost'), findsNothing);
      expect(find.byType(ModalActionButton), findsNWidgets(2));
    });
  });
}
