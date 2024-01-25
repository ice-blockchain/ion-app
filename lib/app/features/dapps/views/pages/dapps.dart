import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/wallet_header/wallet_header.dart';

class DAppsPage extends HookConsumerWidget {
  const DAppsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dApps Page'),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: context.theme.appColors.primaryBackground),
        child: const WalletHeader(),
      ),
    );
  }
}
