// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_tokens_stream_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<Iterable<UserToken>> userTokensStream(UserTokensStreamRef ref) async* {
  final ionClient = await ref.watch(ionApiClientProvider.future);

  await for (final tokens in ionClient.authorizedUsers) {
    yield tokens;
  }
}
