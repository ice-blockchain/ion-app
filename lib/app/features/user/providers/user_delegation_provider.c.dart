// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_delegation_provider.c.g.dart';

@riverpod
Future<UserDelegationEntity?> userDelegation(Ref ref, String pubkey) async {
  final userDelegation = await ref.watch(
    cachedUserDelegationProvider(pubkey).future,
  );

  if (userDelegation != null) {
    return userDelegation;
  }

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(kinds: const [UserDelegationEntity.kind], limit: 1, authors: [pubkey]),
    );

  return ref.read(ionConnectNotifierProvider.notifier).requestEntity<UserDelegationEntity>(
        requestMessage,
        actionSource: const ActionSourceIndexers(),
      );
}

@riverpod
Future<UserDelegationEntity?> cachedUserDelegation(Ref ref, String pubkey) async {
  final userDelegation = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<UserDelegationEntity>(
        CacheableEntity.cacheKeyBuilder(
          eventReference: ReplaceableEventReference(
            pubkey: pubkey,
            kind: UserDelegationEntity.kind,
          ),
        ),
      ),
    ),
  );

  return userDelegation;
}

@riverpod
Future<UserDelegationEntity?> currentUserDelegation(Ref ref) async {
  final mainWallet = await ref.watch(mainWalletProvider.future);
  if (mainWallet == null) {
    return null;
  }

  try {
    return await ref.watch(userDelegationProvider(mainWallet.signingKey.publicKey).future);
  } on UserRelaysNotFoundException catch (_) {
    return null;
  }
}

@riverpod
Future<UserDelegationEntity?> currentUserCachedDelegation(Ref ref) async {
  final mainWallet = await ref.watch(mainWalletProvider.future);
  if (mainWallet == null) {
    return null;
  }

  try {
    return await ref.watch(cachedUserDelegationProvider(mainWallet.signingKey.publicKey).future);
  } on UserRelaysNotFoundException catch (_) {
    return null;
  }
}

@riverpod
class UserDelegationManager extends _$UserDelegationManager {
  @override
  FutureOr<void> build() {}

  Future<UserDelegationData> buildCurrentUserDelegationDataWith({required String pubkey}) async {
    final delegation = (await ref.read(currentUserDelegationProvider.future))?.data ??
        const UserDelegationData(delegates: []);

    return delegation.copyWith(
      delegates: [
        ...delegation.delegates,
        UserDelegate(
          pubkey: pubkey,
          time: DateTime.now(),
          status: DelegationStatus.active,
        ),
      ],
    );
  }
}
