import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/generated/assets.gen.dart';

enum SampleItem { ice, eth, bnb }

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ValueNotifier<SampleItem> selected = useState(SampleItem.ice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Page'),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: context.theme.appColors.primaryBackground),
        child: Center(
          child: Column(
            children: <Widget>[
              Button(
                trailingIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                ),
                leadingIcon: Image.asset(
                  Assets.images.foo.path,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                label: Text(
                  selected.value.toString(),
                ),
                onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
