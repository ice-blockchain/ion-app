import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';

class ChatPage extends IceSimplePage {
  const ChatPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, _, __) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Container(
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
