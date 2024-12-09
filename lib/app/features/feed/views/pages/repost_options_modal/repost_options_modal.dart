// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/content_notification/data/models/content_notification_data.c.dart';
import 'package:ion/app/features/feed/content_notification/providers/content_notification_provider.c.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RepostOptionsModal extends ConsumerWidget {
  const RepostOptionsModal({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(repostNotifierProvider);
    final repostLoading = ref.watch(repostNotifierProvider).isLoading;

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.feed_repost_type),
              leading: NavigationCloseButton(onPressed: context.pop),
            ),
            SizedBox(height: 11.0.s),
            ScreenSideOffset.small(
              child: Button(
                type: ButtonType.secondary,
                mainAxisSize: MainAxisSize.max,
                disabled: repostLoading,
                onPressed: () async {
                  await ref
                      .read(repostNotifierProvider.notifier)
                      .repost(eventReference: eventReference);
                  if (!ref.read(repostNotifierProvider).hasError) {
                    if (context.mounted) {
                      context.pop();
                    }
                    ref
                        .read(contentNotificationControllerProvider.notifier)
                        .showSuccess(ContentType.repost);
                  }
                },
                leadingIcon: repostLoading
                    ? const IONLoadingIndicator(type: IndicatorType.dark)
                    : Assets.svg.iconFeedRepost.icon(size: 18.0.s),
                leadingIconOffset: 12.0.s,
                label: Text(context.i18n.feed_repost),
              ),
            ),
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: Button(
                type: ButtonType.secondary,
                mainAxisSize: MainAxisSize.max,
                onPressed: () {
                  CreatePostRoute(quotedEvent: eventReference.toString()).pushReplacement(context);
                },
                leadingIcon: Assets.svg.iconFeedQuote.icon(size: 18.0.s),
                leadingIconOffset: 12.0.s,
                label: Text(
                  context.i18n.feed_quote_post,
                ),
              ),
            ),
            SizedBox(height: 20.0.s),
          ],
        ),
      ),
    );
  }
}
