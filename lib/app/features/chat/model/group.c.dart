// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/group_type.dart';

part 'group.c.freezed.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String link,
    required String name,
    required List<String> members,
    required GroupType type,
    String? imageUrl,
  }) = _Group;
}
