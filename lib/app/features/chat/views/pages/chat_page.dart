import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/theme.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Container(
        decoration: BoxDecoration(color: context.theme.appColors.background),
        child: Center(
          child: ElevatedButton(
            onPressed: () => const ModalExampleRoute().push(context),
            child: const Text('Open Error Modal'),
          ),
        ),
      ),
    );
  }
}
