import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/data/models/auth_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthenticationUnknown();
  }

  Future<void> rehydrate() async {
    // state = const Unauthenticated();
    state = const Authenticated(authToken: AuthToken(access: 'access', refresh: 'refresh'));
  }

  Future<void> signUp({required String keyName}) async {
    try {
      state = const AuthenticationLoading();

      await Future<void>.delayed(const Duration(seconds: 1));

      state = Authenticated(
        authToken: AuthToken(
          access: 'access',
          refresh: 'refresh',
        ),
      );
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }

  Future<void> signIn({required String keyName}) async {
    try {
      state = const AuthenticationLoading();

      await Future<void>.delayed(const Duration(seconds: 1));

      state = Authenticated(
        authToken: AuthToken(
          access: 'access',
          refresh: 'refresh',
        ),
      );
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      state = const AuthenticationLoading();
      await Future<void>.delayed(const Duration(seconds: 2));
      state = const Unauthenticated();
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }
}
