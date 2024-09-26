import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

@Freezed(copyWith: true, equal: true)
class AuthState with _$AuthState {
  const factory AuthState({
    required List<String> authenticatedUserIds,
    required String? currentUserId,
  }) = _AuthState;
  const AuthState._();

  bool get hasAuthenticated {
    return authenticatedUserIds.isNotEmpty;
  }
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  static const String _authenticatedUserIdsKey = 'Auth:authenticatedUserIds';
  static const String _currentUserIdKey = 'Auth:currentUserId';

  @override
  AsyncValue<AuthState> build() {
    return const AsyncLoading();
  }

  /// Method to init the auth provider with the stored values.
  ///
  /// Using a separate method instead of doing so in the `build` method
  /// to be able to run it only when some conditions are met:
  /// e.g. when the local storage is already initialized.
  Future<void> rehydrate() async {
    final localStorage = ref.read(localStorageProvider);
    await Future<void>.delayed(const Duration(seconds: 1));
    final authenticatedUserIds = localStorage.getStringList(_authenticatedUserIdsKey) ?? [];
    final storedCurrentUserId = localStorage.getString(_currentUserIdKey);
    state = AsyncValue.data(
      AuthState(
        authenticatedUserIds: authenticatedUserIds,
        currentUserId: authenticatedUserIds.contains(storedCurrentUserId)
            ? storedCurrentUserId
            : authenticatedUserIds.isNotEmpty
                ? authenticatedUserIds.last
                : null,
      ),
    );
  }

  Future<void> signUp({required String keyName}) async {
    return signIn(keyName: keyName);
  }

  Future<void> signIn({required String keyName}) async {
    state = const AsyncValue.loading();

    final localStorage = ref.read(localStorageProvider);
    final authenticatedUserIds = ['001', '002', '003'];
    final currentUserId = authenticatedUserIds.first;

    await Future<void>.delayed(const Duration(seconds: 1));

    await Future.wait([
      localStorage.setStringList(_authenticatedUserIdsKey, authenticatedUserIds),
      localStorage.setString(_currentUserIdKey, currentUserId),
    ]);

    state = AsyncData(
      AuthState(authenticatedUserIds: authenticatedUserIds, currentUserId: currentUserId),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    await Future<void>.delayed(const Duration(seconds: 1));

    final localStorage = ref.read(localStorageProvider);

    await Future.wait([
      localStorage.remove(_authenticatedUserIdsKey),
      localStorage.remove(_currentUserIdKey),
    ]);

    state = const AsyncData(AuthState(authenticatedUserIds: [], currentUserId: null));
  }

  void setCurrentUser(String userId) {
    final stateValue = state.valueOrNull;
    if (stateValue == null) return;

    if (stateValue.authenticatedUserIds.contains(userId)) {
      ref.read(localStorageProvider).setString(_currentUserIdKey, userId);
      state = AsyncData(stateValue.copyWith(currentUserId: userId));
    }
  }
}

@riverpod
String currentUserIdSelector(CurrentUserIdSelectorRef ref) {
  return ref.watch(authProvider.select((state) => state.valueOrNull?.currentUserId)) ?? '';
}
