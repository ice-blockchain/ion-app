// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.r.g.dart';

@riverpod
Stream<Iterable<String>> users(Ref ref) async* {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  yield* ionIdentity.authorizedUsers;
}
