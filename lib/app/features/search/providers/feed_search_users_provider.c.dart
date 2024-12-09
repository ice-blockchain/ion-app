// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_users_provider.c.g.dart';

@riverpod
Future<List<String>?> feedSearchUsers(
  Ref ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  return [
    '3fd8d81918d22397223253035f17e9d24f86e7ac2955eb049ccafc9bc14efd80',
    '67d57a558c48dba514aef8bf1d0e750a1279aa305c17eb975e09f6f61b6806ae',
    '87c90e8cffd54892268c1704c15bed93b01388aab4e3c72dc571c52c813b945f',
  ];
}
