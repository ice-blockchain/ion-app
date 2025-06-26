// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.r.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delegation_complete_provider.r.g.dart';

@riverpod
Future<bool> delegationComplete(Ref ref) async {
  final (delegation, eventSigner) = await (
    ref.watch(currentUserDelegationProvider.future),
    ref.watch(currentUserIonConnectEventSignerProvider.future),
  ).wait;

  return delegation != null &&
      eventSigner != null &&
      delegation.data.hasDelegateFor(pubkey: eventSigner.publicKey);
}

@riverpod
Future<bool> cacheDelegationComplete(Ref ref) async {
  final (delegation, eventSigner) = await (
    ref.watch(currentUserCachedDelegationProvider.future),
    ref.watch(currentUserIonConnectEventSignerProvider.future),
  ).wait;

  return delegation != null &&
      eventSigner != null &&
      delegation.data.hasDelegateFor(pubkey: eventSigner.publicKey);
}
