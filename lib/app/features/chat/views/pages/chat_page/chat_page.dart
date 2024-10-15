// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/ion_identity_client_test/ion_identity_client_test_page.dart';
import 'package:ice/app/router/app_routes.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

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
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const IonIdentityClientTestPage(),
                    ),
                  );
                },
                child: const Text('ion-identity-client'),
              ),
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
