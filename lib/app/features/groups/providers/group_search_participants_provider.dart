// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/groups/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_search_participants_provider.g.dart';

@riverpod
Future<List<User>?> groupSearchParticipants(
  Ref ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }

  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // TODO: Replace mocked data
  return [
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      name: 'Alicia Wernet',
      username: 'aliciawernet',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d3',
      name: 'Alicia Wernet',
      username: 'aliciawernet',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d2',
      name: 'Cristian Lower',
      username: 'cristianlower',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d1',
      name: 'Curtis Washington',
      username: 'curtiswashington',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d5',
      name: 'Diedo Shon Li',
      username: 'diedoshonli',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d6',
      name: 'David Peterson',
      username: 'davidpeterson',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd8f0d4',
      name: 'Dennis Musk',
      username: 'dennismusk',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108681cbd7f0d4',
      name: 'Desmond Pierce',
      username: 'desmondpierce',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108632cbd7f0d4',
      name: 'Diedo Shon Li1',
      username: 'diedoshonli',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65729b55d8d6250b7d51cbbea7711412dbb524108632cbd7f0d4',
      name: 'Diedo Shon Li2',
      username: 'diedoshonli',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664e65739b55d8d6250b7d51cbbea7711412dbb524108632cbd7f0d4',
      name: 'Diedo Shon Li3',
      username: 'diedoshonli',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
    User(
      pubKey: 'f5d70542664465719b55d8d6250b7d51cbbea7711412dbb524108632cbd7f0d4',
      name: 'Diedo Shon Li4',
      username: 'diedoshonli',
      avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    ),
  ];
}
