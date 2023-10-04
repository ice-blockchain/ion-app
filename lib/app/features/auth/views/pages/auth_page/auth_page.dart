import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 65,
          ),
          Image.asset(
            Assets.images.iceRound.path,
          ),
          const SizedBox(
            height: 19,
          ),
          Text(
            'Get started',
            style: context.theme.appTextThemes.headline1,
          ),
          Text(
            'Choose your login method',
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              icon: authState is AuthenticationLoading
                  ? const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.login,
                    ),
              label: const Text(
                'Continue',
              ),
              onPressed: () => <void>{
                ref
                    .read(authProvider.notifier)
                    .signIn(email: 'foo@bar.baz', password: '123'),
              },
            ),
          ),
        ],
      ),
    );
  }
}
