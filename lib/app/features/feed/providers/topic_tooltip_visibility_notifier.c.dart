// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/user/providers/have_created_any_posts_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'topic_tooltip_visibility_notifier.c.g.dart';

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
      if (true == haveCreatedAnyPosts) {
        await markAsSeen();
      }
      return haveCreatedAnyPosts == false;
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
