// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:ion/app/features/settings/data/models/content_lang_set.c.dart';
import 'package:ion/app/features/user/data/models/interest_set.c.dart';

class LanguageSyncStrategy implements SyncStrategy<ContentLangSet> {
  LanguageSyncStrategy({required this.sendInterestSet});

  final Future<void> Function(InterestSetData) sendInterestSet;

  @override
  Future<ContentLangSet> send(ContentLangSet prev, ContentLangSet optimistic) async {
    await sendInterestSet(
      InterestSetData(
        type: InterestSetType.languages,
        hashtags: optimistic.hashtags,
      ),
    );
    return optimistic;
  }
}
