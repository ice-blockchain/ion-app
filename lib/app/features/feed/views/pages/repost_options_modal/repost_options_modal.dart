// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/modal_action_button/modal_action_button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/reposted_events_provider.c.dart';
import 'package:ion/app/features/feed/providers/delete_entity_provider.c.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.c.dart';
import 'package:ion/app/features/feed/views/pages/repost_options_modal/repost_option_action.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class RepostOptionsModal extends HookConsumerWidget {
  const RepostOptionsModal({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(repostNotifierProvider);

    final selectedAction = useState<RepostOptionAction?>(null);
    final repostLoading = ref.watch(repostNotifierProvider).isLoading;
    final repostReference = ref.watch(repostReferenceProvider(eventReference));

    final actions = [
      if (repostReference != null) RepostOptionAction.undoRepost else RepostOptionAction.repost,
      RepostOptionAction.quotePost,
    ];

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.feed_repost_type),
              actions: const [NavigationCloseButton()],
            ),
            SizedBox(height: 6.0.s),
            ScreenSideOffset.small(
              child: SeparatedColumn(
                separator: SizedBox(height: 9.0.s),
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final option in actions)
                    ModalActionButton(
                      icon: (repostLoading && selectedAction.value == option)
                          ? const IONLoadingIndicator(type: IndicatorType.dark)
                          : option.getIcon(context),
                      label: option.getLabel(context),
                      labelStyle: context.theme.appTextThemes.body.copyWith(
                        color: option.getLabelColor(context),
                      ),
                      onTap: () async {
                        selectedAction.value = option;
                        switch (option) {
                          case RepostOptionAction.repost:
                            await ref
                                .read(repostNotifierProvider.notifier)
                                .repost(eventReference: eventReference);
                            if (!ref.read(repostNotifierProvider).hasError && context.mounted) {
                              context.pop();
                            }

                          case RepostOptionAction.quotePost:
                            CreatePostRoute(quotedEvent: eventReference.encode()).go(context);

                          case RepostOptionAction.undoRepost:
                            if (repostReference != null) {
                              await ref.read(deleteEntityProvider(repostReference).future);
                              if (context.mounted) {
                                context.pop();
                              }
                            }
                        }
                        selectedAction.value = null;
                      },
                    ),
                ],
              ),
            ),
            SizedBox(height: 20.0.s),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}
