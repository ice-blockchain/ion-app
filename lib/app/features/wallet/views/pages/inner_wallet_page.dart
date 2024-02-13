import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';

class InnerWalletPage extends IceSimplePage {
  const InnerWalletPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, _, __) {
    final AuthState authState = ref.watch(authProvider);
    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inner Wallet Page'),
      ),
      body: Column(
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
          SwitchListTile(
            title: Text(
              'Light Theme',
              style: context.theme.appTextThemes.body2,
            ),
            value: appThemeMode == ThemeMode.light,
            onChanged: (bool isLightTheme) => <ThemeMode>{
              ref.read(appThemeModeProvider.notifier).themeMode =
                  isLightTheme ? ThemeMode.light : ThemeMode.dark,
            },
          ),
        ],
      ),
    );
  }
}
