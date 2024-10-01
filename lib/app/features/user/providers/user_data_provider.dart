// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserData> userData(UserDataRef ref, String userId) async {
  await Future<void>.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
  final user = mockedUserData[userId];
  if (user == null) {
    throw Exception('User with id=$userId not found');
  }
  return user;
}

@riverpod
AsyncValue<UserData> currentUserData(CurrentUserDataRef ref) {
  final currentUserId = ref.watch(currentUserIdSelectorProvider);
  return ref.watch(userDataProvider(currentUserId));
}
