// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.g.dart';

@riverpod
Stream<Iterable<String>> users(Ref ref) async* {
  final ionClient = await ref.watch(ionClientProvider.future);
  yield* ionClient.authorizedUsers;
}
