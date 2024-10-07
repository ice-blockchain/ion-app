// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ice/app/features/user/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_followers_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> userFollowers(UserFollowersRef ref, String userId) async {
  await Future<void>.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
  return mockedUserData.values.toList().sublist(2).map((user) => user.pubkey).toList();
}
