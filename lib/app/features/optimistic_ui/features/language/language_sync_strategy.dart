// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:ion/app/features/settings/model/content_lang_set.f.dart';
import 'package:ion/app/features/user/model/interest_set.f.dart';

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
