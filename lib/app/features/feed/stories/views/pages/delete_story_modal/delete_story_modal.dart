// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/delete_story_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteStoryModal extends HookConsumerWidget {
  const DeleteStoryModal({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  static double get buttonsSize => 56.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonMinimalSize = Size(buttonsSize, buttonsSize);
    final deleteState = ref.watch(deleteStoryControllerProvider);

    ref
      ..displayErrors(deleteStoryControllerProvider)
      ..listenSuccess(
        deleteStoryControllerProvider,
        (_) {
          if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        },
      );

    return ScreenSideOffset.small(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 48.0.s),
          InfoCard(
            iconAsset: Assets.svg.actionCreatepostDeleterole,
            title: context.i18n.delete_story_title,
            description: context.i18n.delete_story_description,
          ),
          SizedBox(height: 28.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Button.compact(
                  type: ButtonType.outlined,
                  label: Text(context.i18n.button_cancel),
                  onPressed: () {
                    ref.read(storyPauseControllerProvider.notifier).paused = false;
                    context.pop(false);
                  },
                  disabled: deleteState.isLoading,
                  minimumSize: buttonMinimalSize,
                ),
              ),
              SizedBox(width: 15.0.s),
              Expanded(
                child: Button.compact(
                  label: Text(context.i18n.button_delete),
                  onPressed: () async {
                    await ref
                        .read(deleteStoryControllerProvider.notifier)
                        .deleteStory(eventReference);
                  },
                  disabled: deleteState.isLoading,
                  minimumSize: buttonMinimalSize,
                  backgroundColor: context.theme.appColors.attentionRed,
                ),
              ),
            ],
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
