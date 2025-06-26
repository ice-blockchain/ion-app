// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/providers/have_created_any_posts_provider.r.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'topic_tooltip_visibility_notifier.r.g.dart';

@riverpod
class TopicTooltipVisibilityNotifier extends _$TopicTooltipVisibilityNotifier {
  static String hasSeenTopicTooltip = 'UserPreferences:hasSeenTopicTooltip';

  @override
  Future<bool> build() async {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService = ref.watch(
      userPreferencesServiceProvider(identityKeyName: identityKeyName),
    );

    final hasSeenTopicsTooltip =
        userPreferencesService.getValue<bool>(hasSeenTopicTooltip) ?? false;
    if (hasSeenTopicsTooltip) {
      return false;
    } else {
      final haveCreatedAnyPosts = await ref.watch(haveCreatedAnyPostsProvider.future);
      if (haveCreatedAnyPosts) {
        await markAsSeen();
      }
      return !haveCreatedAnyPosts;
    }
  }

  Future<void> markAsSeen() {
    state = const AsyncValue.data(false);
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    return userPreferencesService.setValue<bool>(hasSeenTopicTooltip, true);
  }
}
