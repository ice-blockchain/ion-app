import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ChatPage extends IceSimplePage {
  const ChatPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: context.theme.appColors.attentionRed),
        child: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {}, //TODO add modal??
                child: const Text('Open Error Modal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
