import 'package:flutter/material.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/data/models/auth_token.dart';
import 'package:ice/app/features/core/providers/env_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthenticationUnknown();
  }

  Future<void> rehydrate() async {
    final foo = ref.read(envProvider.notifier).get(EnvVariable.FOO);
    // ignore: avoid_print
    print('Env is $foo');
    state = const Authenticated(
      authToken: AuthToken(access: 'access', refresh: 'refresh'),
    );
  }

  Future<void> signUp({required String keyName}) async {
    try {
      state = const AuthenticationLoading();

      final ionClient = ref.read(ionApiClientProvider);
      final result = await ionClient.auth.registerUser(username: keyName);
      debugPrint('registerUser result: $result');

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

      final ionClient = ref.read(ionApiClientProvider);
      await ionClient.auth.loginUser(username: keyName);
      await ionClient.wallets.listWallets();

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
      state = const UnAuthenticated();
    } catch (error) {
      state = AuthenticationFailure(message: error.toString());
      rethrow;
    }
  }
}
