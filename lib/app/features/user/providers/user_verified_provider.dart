import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_verified_provider.g.dart';

@Riverpod(keepAlive: true)
bool userVerified(UserVerifiedRef ref, String userId) {
  return Random().nextBool();
}
