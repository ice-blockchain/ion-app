import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/data/models/auth_token.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  static const String authTokenKey = 'authToken';

  @override
  AuthState build() {
    return const AuthenticationUnknown();
  }

  Future<void> rehydrate() async {
    final activeUser = ref.read(userDataNotifierProvider);
    final storedToken = ref
            .read(userPreferencesServiceProvider(userId: activeUser.id))
            .getValue<String>(authTokenKey) ??
        '';

    state = storedToken.isEmpty
        ? const Unauthenticated()
        : Authenticated(
            authToken: AuthToken(
              access: storedToken,
              refresh: 'refresh',
            ),
          );
  }

  Future<void> signUp({required String keyName}) async {
    try {
      state = const AuthenticationLoading();

      await Future<void>.delayed(const Duration(seconds: 1));

      final activeUser = ref.read(userDataNotifierProvider);

      final authToken = AuthToken(
        access: 'access',
        refresh: 'refresh',
      );

      ref
          .read(userPreferencesServiceProvider(userId: activeUser.id))
          .setValue(authTokenKey, authToken.access);

      state = Authenticated(authToken: authToken);
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }

  Future<void> signIn({required String keyName}) async {
    try {
      state = const AuthenticationLoading();

      await Future<void>.delayed(const Duration(seconds: 1));

      final activeUser = ref.read(userDataNotifierProvider);

      final authToken = AuthToken(
        access: 'access',
        refresh: 'refresh',
      );

      ref
          .read(userPreferencesServiceProvider(userId: activeUser.id))
          .setValue(authTokenKey, authToken.access);

      state = Authenticated(authToken: authToken);
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      state = const AuthenticationLoading();
      await Future<void>.delayed(const Duration(seconds: 2));

      final activeUser = ref.read(userDataNotifierProvider);

      ref.read(userPreferencesServiceProvider(userId: activeUser.id)).setValue(authTokenKey, '');

      state = const Unauthenticated();
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }
}
