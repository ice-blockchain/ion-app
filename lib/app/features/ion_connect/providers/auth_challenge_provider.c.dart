// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_challenge_provider.c.g.dart';

@Riverpod(keepAlive: true)
class AuthChallenge extends _$AuthChallenge {
  @override
  String? build(IonConnectRelay relay) => null;

  set setChallenge(String challenge) => state = challenge;
}
