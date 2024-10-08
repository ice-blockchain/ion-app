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
    required String? selectedIdentityKeyName,
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
    final authorizedUsers = await ref.watch(authenticatedIdentityKeyNamesStreamProvider.future);
    final savedSelectedUser = await ref.watch(selectedIdentityKeyNameStoreProvider.future);

    final fakeUsers = authorizedUsers.isEmpty
        ? <String>[]
        : [
            ...authorizedUsers,
            'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
            '52d119f46298a8f7b08183b96d4e7ab54d6df0853303ad4a3c3941020f286129',
            '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
          ];

    final selectedUser =
        fakeUsers.contains(savedSelectedUser) ? savedSelectedUser : authorizedUsers.lastOrNull;

    return AuthState(
      authenticatedIdentityKeyNames: authorizedUsers.toList(),
      selectedIdentityKeyName: selectedUser,
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    final currentUser = state.valueOrNull?.selectedIdentityKeyName;
    if (currentUser == null) return;

    final ionClient = await ref.read(ionApiClientProvider.future);
    await ionClient(username: currentUser).auth.logOut();
  }

  void selectUser(String identityKeyName) {
    ref.read(selectedIdentityKeyNameStoreProvider.notifier).selectIdentityKeyName(identityKeyName);
  }
}

@riverpod
String currentUserIdSelector(CurrentUserIdSelectorRef ref) {
  return ref.watch(
    authProvider.select((state) => state.valueOrNull?.selectedIdentityKeyName ?? ''),
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
class SelectedIdentityKeyNameStore extends _$SelectedIdentityKeyNameStore {
  static const String _currentUserIdKey = 'Auth:currentUserId';

  @override
  Future<String?> build() async {
    // Watch prefs to be sure LocalStorage is initialized
    await ref.watch(sharedPreferencesProvider.future);

    final localStorage = ref.watch(localStorageProvider);

    return localStorage.getString(_currentUserIdKey);
  }

  Future<void> selectIdentityKeyName(String identityKeyName) async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setString(_currentUserIdKey, identityKeyName);
    state = AsyncData(identityKeyName);
  }
}
