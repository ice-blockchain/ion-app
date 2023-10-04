import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/router/app_routes.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);

    final ValueNotifier<SampleItem?> selected = useState(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Page'),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: context.theme.appColors.primaryBackground),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MenuAnchor(
                alignmentOffset: const Offset(0, 8),
                builder: (
                  BuildContext context,
                  MenuController controller,
                  Widget? child,
                ) {
                  return ElevatedButton.icon(
                    label: Text(selected.value.toString()),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.more_horiz),
                  );
                },
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () => selected.value = SampleItem.itemOne,
                    leadingIcon: const Icon(Icons.account_balance_sharp),
                    child: const Text('Item one'),
                  ),
                  MenuItemButton(
                    onPressed: () => selected.value = SampleItem.itemTwo,
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.account_balance_sharp),
                        Text('Item long eeeeee'),
                      ],
                    ),
                  ),
                  MenuItemButton(
                    onPressed: () => selected.value = SampleItem.itemThree,
                    leadingIcon: const Icon(Icons.account_balance_sharp),
                    child: const Text('Item three'),
                  ),
                ],
              ),
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
              ElevatedButton(
                onPressed: () => const InnerWalletRoute().go(context),
                child: const Text('Go To Inner Wallet'),
              ),
              Text(
                'Styled Text',
                style: context.theme.appTextThemes.subtitle.copyWith(
                  color: context.theme.appColors.attentionRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SwitchListTile(
                title: Text(
                  'Light Theme',
                  style: context.theme.appTextThemes.subtitle,
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
