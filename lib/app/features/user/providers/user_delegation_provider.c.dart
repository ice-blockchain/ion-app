// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/wallets/providers/main_wallet_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_delegation_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<UserDelegationEntity?> userDelegation(Ref ref, String pubkey) async {
  final userDelegation = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<UserDelegationEntity>(UserDelegationEntity.cacheKeyBuilder(pubkey: pubkey)),
    ),
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

@Riverpod(keepAlive: true)
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

  Future<EventMessage> buildDelegationEventFrom(
    UserDelegationData userDelegationData,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider)!;
    final mainWallet = (await ref.read(mainWalletProvider.future))!;
    final ionIdentity = await ref.read(ionIdentityProvider.future);

    final tags = userDelegationData.tags;
    final createdAt = DateTime.now();
    const kind = UserDelegationEntity.kind;
    final masterPubkey = mainWallet.signingKey.publicKey;

    final eventId = EventMessage.calculateEventId(
      publicKey: masterPubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
    );

    final signResponse = await onVerifyIdentity(
      onPasswordFlow: ({required String password}) {
        return ionIdentity(username: currentIdentityKeyName)
            .wallets
            .generateHashSignatureWithPassword(mainWallet.id, eventId, password);
      },
      onPasskeyFlow: () {
        return ionIdentity(username: currentIdentityKeyName)
            .wallets
            .generateHashSignatureWithPasskey(mainWallet.id, eventId);
      },
      onBiometricsFlow: ({required String localisedReason}) {
        return ionIdentity(username: currentIdentityKeyName)
            .wallets
            .generateHashSignatureWithBiometrics(mainWallet.id, eventId, localisedReason);
      },
    );

    final curveName = switch (mainWallet.signingKey.curve) {
      'ed25519' => 'curve25519',
      _ => throw UnsupportedSignatureAlgorithmException(mainWallet.signingKey.curve)
    };

    final signaturePrefix = '${mainWallet.signingKey.scheme}/$curveName'.toLowerCase();
    final signatureBody =
        '${signResponse.signature['r']}${signResponse.signature['s']}'.replaceAll('0x', '');
    final signature = '$signaturePrefix:$signatureBody';

    return EventMessage(
      id: eventId,
      pubkey: masterPubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
      sig: signature,
    );
  }
}
