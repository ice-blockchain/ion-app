// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class PostNotFound extends StatelessWidget {
  const PostNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(context.i18n.post_page_title),
      ),
      body: const Center(
        child: Text('Post not found'),
      ),
    );
  }
}
