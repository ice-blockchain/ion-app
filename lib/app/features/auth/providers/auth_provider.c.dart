// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/local_passkey_creds_provider.c.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/user/providers/biometrics_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
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
    required bool suggestToCreateLocalPasskeyCreds,
    required bool hasEventSigner,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated {
    return authenticatedIdentityKeyNames.isNotEmpty &&
        !suggestToAddBiometrics &&
        !suggestToCreateLocalPasskeyCreds &&
        hasEventSigner;
  }
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    Logger.log('XXX: Auth: building');

    Logger.log('XXX: Auth: getting authenticated identity key names');
    final authenticatedIdentityKeyNames =
        await ref.watch(authenticatedIdentityKeyNamesStreamProvider.future);
    Logger.log('XXX: Auth: getting saved identity key name');
    final savedIdentityKeyName = await ref.watch(currentIdentityKeyNameStoreProvider.future);

    Logger.log('XXX: Auth: getting current identity key name');
    final currentIdentityKeyName = authenticatedIdentityKeyNames.contains(savedIdentityKeyName)
        ? savedIdentityKeyName
        : authenticatedIdentityKeyNames.lastOrNull;

    Logger.log('XXX: Auth: getting biometrics states');
    final biometricsStates = await ref.watch(biometricsStatesStreamProvider.future);
    Logger.log('XXX: Auth: getting local passkey creds states');
    final localPasskeyCredsStates = await ref.watch(localPasskeyCredsStatesStreamProvider.future);

    Logger.log('XXX: Auth: getting user biometrics state');
    final userBiometricsState =
        currentIdentityKeyName != null ? biometricsStates[currentIdentityKeyName] : null;

    Logger.log('XXX: Auth: getting user local passkey creds state');
    final userLocalPasskeyCredsState =
        currentIdentityKeyName != null ? localPasskeyCredsStates[currentIdentityKeyName] : null;

    Logger.log('XXX: Auth: getting event signer');
    final eventSigner = currentIdentityKeyName != null
        ? await ref
            .watch(ionConnectEventSignerProvider(currentIdentityKeyName).notifier)
            .initEventSigner()
        : null;

    Logger.log('XXX: Auth: eventSigner==null? ${eventSigner == null}');

    Logger.log('XXX: Auth: creating state');
    final state = AuthState(
      authenticatedIdentityKeyNames: authenticatedIdentityKeyNames.toList(),
      currentIdentityKeyName: currentIdentityKeyName,
      suggestToAddBiometrics: userBiometricsState == BiometricsState.canSuggest,
      suggestToCreateLocalPasskeyCreds:
          userLocalPasskeyCredsState == LocalPasskeyCredsState.canSuggest,
      hasEventSigner: eventSigner != null,
    );

    Logger.log('XXX: Auth: state: $state');
    return state;
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

@Riverpod(keepAlive: true)
class CurrentPubkeySelector extends _$CurrentPubkeySelector {
  @override
  String? build() {
    listenSelf((_, next) => _saveState(next));
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName == null) {
      return null;
    }
    final mainWallet = ref.watch(mainWalletProvider).valueOrNull;
    return mainWallet?.signingKey.publicKey;
  }

  Future<void> _saveState(String? pubkey) async {
    // Saving current master pubkey using sharedPreferencesFoundation
    // to be able to read this value in the iOS Notification Service Extension
    final sharedPreferencesFoundation = await ref.read(sharedPreferencesFoundationProvider.future);
    if (pubkey == null) {
      await sharedPreferencesFoundation.remove(persistenceKey);
    } else {
      await sharedPreferencesFoundation.setString(persistenceKey, pubkey);
    }
  }

  static const persistenceKey = 'current_master_pubkey';
}

@riverpod
bool isCurrentUserSelector(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
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
    final localStorage = await ref.watch(localStorageAsyncProvider.future);
    return localStorage.getString(_currentIdentityKeyNameKey);
  }

  Future<void> setCurrentIdentityKeyName(String identityKeyName) async {
    final localStorage = await ref.read(localStorageAsyncProvider.future);
    await localStorage.setString(_currentIdentityKeyNameKey, identityKeyName);
    state = AsyncData(identityKeyName);
  }
}

void onLogout(Ref ref, void Function() callback) {
  ref.listen(authProvider.select((state) => state.valueOrNull?.isAuthenticated), (prev, next) {
    if (prev != null && prev == true && next == false) {
      callback();
    }
  });
}

void keepAliveWhenAuthenticated(Ref ref) {
  final keepAlive = ref.keepAlive();
  onLogout(ref, keepAlive.close);
}
