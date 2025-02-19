// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/banuba_service.c.dart';

class StoryRecordPage extends HookConsumerWidget {
  const StoryRecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banubaState = ref.watch(banubaEditorNotifierProvider);

    final showLoading = useState(false);

    useOnInit(() async {
      await ref.read(banubaEditorNotifierProvider.notifier).startEditor();

      showLoading.value = true;
    });

    useEffect(
      () {
        banubaState.when(
          idle: () => showLoading.value = false,
          loading: () => showLoading.value = true,
          ready: (exportedPath) async {
            showLoading.value = false;

            if (exportedPath != null) {
              if (context.mounted) {
                final isPublished = await StoryPreviewRoute(
                  path: exportedPath,
                  mimeType: 'video/mp4',
                ).push<bool>(context);

                if (isPublished ?? false) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  ref.invalidate(banubaEditorNotifierProvider);
                  await Future.microtask(() {
                    if (context.mounted) {
                      ref.read(banubaEditorNotifierProvider.notifier).startEditor();
                    }
                  });
                }
              }
            }
          },
          error: (message) => showLoading.value = false,
        );
        return null;
      },
      [banubaState],
    );

    return Scaffold(
      body: Center(
        child: showLoading.value ? const IONLoadingIndicatorThemed() : const SizedBox.shrink(),
      ),
    );
  }
}
