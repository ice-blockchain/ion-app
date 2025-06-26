// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_model.dart';

part 'content_lang_set.f.freezed.dart';

@freezed
class ContentLangSet with _$ContentLangSet implements OptimisticModel {
  const factory ContentLangSet({
    required String pubkey,
    required List<String> hashtags,
  }) = _ContentLangSet;

  const ContentLangSet._();

  @override
  String get optimisticId => pubkey;

  ContentLangSet get sorted => copyWith(hashtags: List.of(hashtags)..sort());
}
