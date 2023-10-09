import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/shared/widgets/action_button/action_button.dart';
import 'package:ice/app/shared/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:ice/app/shared/widgets/list_item/list_item.dart';
import 'package:ice/generated/assets.gen.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);

    final ValueNotifier<SampleItem> selected = useState(SampleItem.itemOne);

    final ValueNotifier<bool> checked = useState(false);

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
              ListItem.checkbox(
                onTap: () => checked.value = !checked.value,
                value: checked.value,
                title: const Text('ice.wallet'),
              ),
              ListItem(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.asset(
                    Assets.images.foo.path,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Etherium'),
                subtitle: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ETHad',
                    ),
                    Text(
                      'ETHad !',
                    ),
                  ],
                ),
              ),
              ActionButton(
                label: const Icon(
                  Icons.add,
                  size: 24,
                ),
                onPressed: () {},
              ),
              DropDownMenu(
                builder: (
                  BuildContext context,
                  MenuController controller,
                  Widget? child,
                ) {
                  return ActionButton(
                    leadingIcon: Image.asset(
                      Assets.images.foo.path,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    label: Text(
                      selected.value.toString(),
                    ),
                    trailingIcon: Icon(
                      controller.isOpen
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                    ),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
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
