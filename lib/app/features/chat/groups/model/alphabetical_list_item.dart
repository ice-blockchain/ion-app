// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/groups/model/user.dart';

part 'alphabetical_list_item.freezed.dart';

@freezed
sealed class AlphabeticalListItem with _$AlphabeticalListItem {
  const factory AlphabeticalListItem.user(User user) = UserItem;
  const factory AlphabeticalListItem.header(String title) = _HeaderItem;
}
