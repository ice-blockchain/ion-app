// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class AppTestPage extends ConsumerWidget {
  const AppTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: context.theme.appColors.attentionRed),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Open Error Modal'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                },
                child: const Text('Logout'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  CompressTestRoute().push<void>(context);
                },
                child: const Text('Compress Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
