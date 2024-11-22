// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/groups/model/alphabetical_list_item.dart';
import 'package:ion/app/features/chat/groups/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alphabetical_list_provider.g.dart';

@riverpod
Future<List<AlphabeticalListItem>?> transformWithAlphabeticalHeaders(
  Ref ref, {
  required Iterable<User>? input,
}) async {
  if (input == null) return null;
  if (input.isEmpty) return [];

  final sorted = input.sorted((a, b) => a.name[0].compareTo(b.name[0]));
  var header = sorted.first.name[0].toUpperCase();
  final result = <AlphabeticalListItem>[];

  for (final user in sorted) {
    final firstLetter = user.name[0].toUpperCase();

    if (header != firstLetter) {
      header = firstLetter;
      result.add(
        AlphabeticalListItem.header(header),
      );
    }

    result.add(
      AlphabeticalListItem.user(user),
    );
  }

  return result;
}
