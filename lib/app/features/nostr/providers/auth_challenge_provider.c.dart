// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_challenge_provider.c.g.dart';

@Riverpod(keepAlive: true)
class AuthChallenge extends _$AuthChallenge {
  @override
  String? build(String url) => null;

  set setChallenge(String challenge) => state = challenge;

  void clearChallenge() => state = null;
}
