// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserData> userData(UserDataRef ref, String pubkey) async {
  final relay = await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [0], authors: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    return UserData.fromEventMessage(events.first);
  }
  return UserData(pubkey: pubkey);
}

@riverpod
AsyncValue<UserData> currentUserData(CurrentUserDataRef ref) {
  final currentUserId = ref.watch(currentUserIdSelectorProvider);
  return ref.watch(userDataProvider(currentUserId));
}
