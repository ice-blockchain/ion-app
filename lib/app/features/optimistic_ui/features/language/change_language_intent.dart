// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/optimistic_ui/core/optimistic_intent.dart';
import 'package:ion/app/features/settings/model/content_lang_set.f.dart';

class ChangeLanguageIntent implements OptimisticIntent<ContentLangSet> {
  ChangeLanguageIntent(this.iso);
  final String iso;

  @override
  ContentLangSet optimistic(ContentLangSet current) {
    final updated = {...current.hashtags};
    updated.contains(iso) ? updated.remove(iso) : updated.add(iso);

    return current.copyWith(hashtags: updated.toList()).sorted;
  }

  @override
  Future<ContentLangSet> sync(ContentLangSet prev, ContentLangSet next) async => next;
}
