// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class ArticleRepliesPage extends HookConsumerWidget {
  const ArticleRepliesPage({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

    if (entity is! ArticleEntity) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(context.i18n.common_comments),
        actions: [
          BookmarkButton(eventReference: eventReference),
        ],
      ),
      body: const Column(
        children: [
          HorizontalSeparator(),
        ],
      ),
    );
  }
}
