import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/generated/app_localizations.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text(I18n.of(context)!.hello('Kir'))),
      body: Column(
        children: <Widget>[
          Center(
            child: ElevatedButton.icon(
              icon: authState is AuthenticationLoading
                  ? const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Icon(Icons.login),
              label: const Text('sign in'),
              onPressed: () => <void>{
                ref
                    .read(authProvider.notifier)
                    .signIn(email: 'foo@bar.baz', password: '123'),
              },
            ),
          ),
          Image.asset(Assets.images.foo.path),
        ],
      ),
    );
  }
}
