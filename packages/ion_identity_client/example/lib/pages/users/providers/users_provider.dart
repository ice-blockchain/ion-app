// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.g.dart';

@riverpod
Stream<Iterable<String>> users(UsersRef ref) async* {
  final ionClient = await ref.watch(ionClientProvider.future);
  await for (final tokens in ionClient.authorizedUsers) {
    yield tokens.map((e) => e.username);
  }
}
