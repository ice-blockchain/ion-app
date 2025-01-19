// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channels_provider.c.g.dart';

@Riverpod(keepAlive: true)
class Channels extends _$Channels {
  @override
  FutureOr<void> build() async {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

    if (currentUserPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final eventStream = ref.watch(ionConnectNotifierProvider.notifier).requestEntities(
          RequestMessage()
            ..addFilter(
              RequestFilter(
                kinds: const [1750],
                authors: [currentUserPubkey],
                limit: 1,
              ),
            ),
        );

    final channels = await eventStream.cast<Object>().toList();

    return;
  }
}
