// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/components/modal_action_button/modal_action_button.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:ion/app/features/feed/views/pages/repost_options_modal/repost_options_modal.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../../../../helpers/robot_test_harness.dart';
import '../../../helpers/repost_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  group('RepostOptionsModal', () {
    const eventReference = RepostTestConstants.eventReference;

    testWidgets('shows correct options when not reposted', (tester) async {
      final postRepost = PostRepostFactory.createNotReposted(
        repostsCount: 5,
        quotesCount: 3,
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

      expect(find.byType(ModalActionButton), findsNWidgets(2));

      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Undo repost'), findsNothing);
      expect(find.text('Quote'), findsOneWidget);

      final repostOptionsModalWidget = tester.widget<RepostOptionsModal>(
        find.byType(RepostOptionsModal),
      );
      expect(repostOptionsModalWidget.eventReference, eventReference);
    });

    testWidgets('shows correct options when already reposted', (tester) async {
      final postRepost = PostRepostFactory.createReposted(
        repostsCount: 6,
        quotesCount: 3,
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

      expect(find.byType(ModalActionButton), findsNWidgets(2));

      expect(find.text('Undo repost'), findsOneWidget);
      expect(find.text('Repost'), findsNothing);
      expect(find.text('Quote'), findsOneWidget);
    });

    testWidgets('shows undo option after repost via OptimisticService', (tester) async {
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

      streamController.add(PostRepostFactory.createNotReposted());
      await tester.pumpAndSettle();

      expect(find.byType(ModalActionButton), findsNWidgets(2));

      streamController.add(PostRepostFactory.createReposted());
      await tester.pumpAndSettle();

      expect(find.byType(ModalActionButton), findsNWidgets(2));

      await streamController.close();
    });

    testWidgets('handles null state from provider gracefully', (tester) async {
      await tester.pumpWithHarness(
        childBuilder: (_) => const RepostOptionsModal(eventReference: eventReference),
        overrides: [
          postRepostWatchProvider(eventReference.toString()).overrideWith(
            (ref) => Stream.value(null),
          ),
        ],
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,
      );

      await tester.pumpAndSettle();

      expect(find.byType(ModalActionButton), findsNWidgets(2));
    });

    testWidgets('shows correct state after cache invalidation', (tester) async {
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

      streamController.add(PostRepostFactory.createReposted(repostsCount: 6));
      await tester.pumpAndSettle();

      expect(find.text('Undo repost'), findsOneWidget);
      expect(find.text('Repost'), findsNothing);

      streamController.add(null);
      await tester.pumpAndSettle();

      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Undo repost'), findsNothing);

      streamController.add(PostRepostFactory.createNotReposted(repostsCount: 5));
      await tester.pumpAndSettle();

      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Undo repost'), findsNothing);

      await streamController.close();
    });
  });
}
