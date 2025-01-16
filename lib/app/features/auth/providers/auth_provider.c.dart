// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/user/providers/biometrics_provider.c.dart';
import 'package:ion/app/features/wallets/providers/main_wallet_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.c.freezed.dart';
part 'auth_provider.c.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required List<String> authenticatedIdentityKeyNames,
    required String? currentIdentityKeyName,
    required bool suggestToAddBiometrics,
    required bool hasEventSigner,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated {
    return authenticatedIdentityKeyNames.isNotEmpty && !suggestToAddBiometrics && hasEventSigner;
  }
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    final authenticatedIdentityKeyNames =
        await ref.watch(authenticatedIdentityKeyNamesStreamProvider.future);
    final savedIdentityKeyName = await ref.watch(currentIdentityKeyNameStoreProvider.future);

    final currentIdentityKeyName = authenticatedIdentityKeyNames.contains(savedIdentityKeyName)
        ? savedIdentityKeyName
        : authenticatedIdentityKeyNames.lastOrNull;
    final biometricsStates = await ref.watch(biometricsStatesStreamProvider.future);
    final userBiometricsState =
        currentIdentityKeyName != null ? biometricsStates[currentIdentityKeyName] : null;
    final eventSigner = currentIdentityKeyName != null
        ? await ref
            .watch(ionConnectEventSignerProvider(currentIdentityKeyName).notifier)
            .initEventSigner()
        : null;

    return AuthState(
      authenticatedIdentityKeyNames: authenticatedIdentityKeyNames.toList(),
      currentIdentityKeyName: currentIdentityKeyName,
      suggestToAddBiometrics: userBiometricsState == BiometricsState.canSuggest,
      hasEventSigner: eventSigner != null,
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    final currentUser = state.valueOrNull?.currentIdentityKeyName;
    if (currentUser == null) return;

    final ionIdentity = await ref.read(ionIdentityProvider.future);
    await ionIdentity(username: currentUser).auth.logOut();
  }

  void setCurrentUser(String identityKeyName) {
    ref
        .read(currentIdentityKeyNameStoreProvider.notifier)
        .setCurrentIdentityKeyName(identityKeyName);
  }
}

@Riverpod(keepAlive: true)
String? currentIdentityKeyNameSelector(Ref ref) {
  return ref.watch(
    authProvider.select((state) => state.valueOrNull?.currentIdentityKeyName),
  );
}

@riverpod
Future<String?> currentPubkeySelector(Ref ref) async {
  final mainWallet = await ref.watch(mainWalletProvider.future);
  if (mainWallet == null) {
    return null;
  }
  return mainWallet.signingKey.publicKey;
}

@riverpod
bool isCurrentUserSelector(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  return currentPubkey == pubkey;
}

@Riverpod(keepAlive: true)
Stream<Iterable<String>> authenticatedIdentityKeyNamesStream(Ref ref) async* {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);

  yield* ionIdentity.authorizedUsers;
}

@Riverpod(keepAlive: true)
class CurrentIdentityKeyNameStore extends _$CurrentIdentityKeyNameStore {
  static const String _currentIdentityKeyNameKey = 'Auth:currentIdentityKeyName';

  @override
  Future<String?> build() async {
    // Watch prefs to be sure LocalStorage is initialized
    await ref.watch(sharedPreferencesProvider.future);

    final localStorage = ref.watch(localStorageProvider);

    return localStorage.getString(_currentIdentityKeyNameKey);
  }

  Future<void> setCurrentIdentityKeyName(String identityKeyName) async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setString(_currentIdentityKeyNameKey, identityKeyName);
    state = AsyncData(identityKeyName);
  }
}
