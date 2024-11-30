// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_followers_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> userFollowers(Ref ref, String pubkey) async {
  await Future<void>.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
  return [
    'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
    '52d119f46298a8f7b08183b96d4e7ab54d6df0853303ad4a3c3941020f286129',
  ];
}
