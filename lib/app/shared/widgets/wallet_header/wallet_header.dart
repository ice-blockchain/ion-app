import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletHeader extends HookConsumerWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Button(
      trailingIcon: const Icon(
        Icons.arrow_drop_down_rounded,
      ),
      leadingIcon: Image.asset(
        Assets.images.foo.path,
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      ),
      label: const Text('ice.wallet'),
      onPressed: () {},
    );
  }
}
