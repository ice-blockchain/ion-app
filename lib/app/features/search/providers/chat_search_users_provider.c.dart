// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_search_users_provider.c.g.dart';

@riverpod
Future<List<String>?> chatSearchUsers(
  Ref ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  return [
    'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
    '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
    '5f010febe730be42d18c3bf9bf3a135f90621dc572175b5c357119533ae9756b',
    'e202c8e80569fc35caee8325e2b6353018c286c9afcb1569ebde635d689bdfd1',
  ];
}
