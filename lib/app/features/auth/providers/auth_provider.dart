// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

@Freezed(copyWith: true, equal: true)
class AuthState with _$AuthState {
  const factory AuthState({
    required List<String> authenticatedIdentityKeyNames,
    required String? currentIdentityKeyName,
  }) = _AuthState;
  const AuthState._();

  bool get hasAuthenticated {
    return authenticatedIdentityKeyNames.isNotEmpty;
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

    return AuthState(
      authenticatedIdentityKeyNames: authenticatedIdentityKeyNames.toList(),
      currentIdentityKeyName: currentIdentityKeyName,
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    final currentUser = state.valueOrNull?.currentIdentityKeyName;
    if (currentUser == null) return;

    final ionClient = await ref.read(ionApiClientProvider.future);
    await ionClient(username: currentUser).auth.logOut();
  }

  void setCurrentUser(String identityKeyName) {
    ref
        .read(currentIdentityKeyNameStoreProvider.notifier)
        .setCurrentIdentityKeyName(identityKeyName);
  }
}

@Riverpod(keepAlive: true)
String? currentIdentityKeyNameSelector(CurrentIdentityKeyNameSelectorRef ref) {
  return ref.watch(
    authProvider.select((state) => state.valueOrNull?.currentIdentityKeyName),
  );
}

@Riverpod(keepAlive: true)
Stream<Iterable<String>> authenticatedIdentityKeyNamesStream(
  AuthenticatedIdentityKeyNamesStreamRef ref,
) async* {
  final ionClient = await ref.watch(ionApiClientProvider.future);

  yield* ionClient.authorizedUsers;
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
