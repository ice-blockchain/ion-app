// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_relays_ranker.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranked_user_chat_relays_provider.c.g.dart';

@riverpod
Future<UserChatRelaysEntity?> rankedCurrentUserChatRelays(Ref ref) async {
  final pubkey = ref.read(currentPubkeySelectorProvider);
  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }
  final currentUserChatRelayEntity = await ref.watch(userChatRelaysProvider(pubkey).future);
  return ref.watch(rankedChatRelayProvider(currentUserChatRelayEntity).future);
}

@riverpod
Future<UserChatRelaysEntity?> rankedChatRelay(
  Ref ref,
  UserChatRelaysEntity? chatRelayEntity,
) async {
  if (chatRelayEntity == null) {
    return null;
  }
  final cancelToken = CancelToken();
  final relaysUrls = chatRelayEntity.data.list.map((e) => e.url).toList();
  final rankedRelaysUrls = await ref.watch(ionConnectRelaysRankerProvider).ranked(
        relaysUrls,
        cancelToken: cancelToken,
      );
  final rankedRelays = rankedRelaysUrls
      .map(
        (url) => chatRelayEntity.data.list.firstWhereOrNull((e) => e.url == url),
      )
      .nonNulls
      .toList();

  final updatedChatRelayEntity = chatRelayEntity.copyWith(
    data: chatRelayEntity.data.copyWith(list: rankedRelays),
  );
  return updatedChatRelayEntity;
}
