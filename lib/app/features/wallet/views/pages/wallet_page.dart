import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';
import 'package:ice/app/theme/theme.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Page'),
      ),
      body: Container(
        decoration: BoxDecoration(color: context.theme.appColors.background),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                label: const Text('Sign Out'),
                icon: authState is AuthenticationLoading
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Icon(Icons.logout),
                onPressed: ref.read(authProvider.notifier).signOut,
              ),
              Text(
                'Styled Text',
                style: context.theme.appTextThemes.body1.copyWith(
                  color: context.theme.appColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SwitchListTile(
                title: Text(
                  'Light Theme',
                  style: context.theme.appTextThemes.body1,
                ),
                value: appThemeMode == ThemeMode.light,
                onChanged: (bool isLightTheme) => <ThemeMode>{
                  ref.read(appThemeModeProvider.notifier).themeMode =
                      isLightTheme ? ThemeMode.light : ThemeMode.dark,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
