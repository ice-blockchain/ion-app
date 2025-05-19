// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/separated/separated_row.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/share/share.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ShareOptions extends HookConsumerWidget {
  const ShareOptions({required this.eventReference, super.key});

  final EventReference eventReference;

  static double get iconSize => 28.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshotController = useMemoized(ScreenshotController.new);
    final isCapturing = useState(false);

    final entity = ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

    if (entity == null) {
      return const SizedBox.shrink();
    }

    final isPost = entity is ModifiablePostEntity && entity.data.expiration == null;

    final shareUrl = eventReference.encode();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 20.0.s, end: 16.0.s, start: 16.0.s),
        child: SeparatedRow(
          separator: SizedBox(width: 12.0.s),
          children: [
            if (isPost)
              _ShareOptionsMenuItem(
                buttonType: ButtonType.primary,
                icon: isCapturing.value
                    ? const CenteredLoadingIndicator()
                    : Assets.svg.iconFeedStories.icon(size: iconSize),
                label: context.i18n.feed_add_story,
                onPressed: isCapturing.value
                    ? () {}
                    : () async {
                        isCapturing.value = true;

                        try {
                          final imageBytes = await screenshotController.captureFromWidget(
                            Localizations.override(
                              context: context,
                              locale: Localizations.localeOf(context),
                              child: MediaQuery(
                                data: MediaQuery.of(context),
                                child: Directionality(
                                  textDirection: Directionality.of(context),
                                  child: InheritedTheme.captureAll(
                                    context,
                                    ProviderScope(
                                      overrides: [
                                        currentIdentityKeyNameSelectorProvider.overrideWithValue(
                                          ref.read(currentIdentityKeyNameSelectorProvider),
                                        ),
                                        currentPubkeySelectorProvider
                                            .overrideWith(CurrentPubkeySelector.new),
                                        ionConnectEntityWithCountersProvider(
                                          eventReference: eventReference,
                                        ).overrideWithValue(
                                          entity,
                                        ),
                                      ],
                                      child: Material(
                                        child: Post(
                                          eventReference: eventReference,
                                          contentWrapper: (content) => Container(
                                            decoration: BoxDecoration(
                                              color: context.theme.appColors.primaryBackground,
                                              borderRadius: BorderRadius.circular(16.0.s),
                                            ),
                                            padding: EdgeInsets.all(16.0.s),
                                            child: content,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            pixelRatio: 2,
                            delay: const Duration(milliseconds: 100),
                          );

                          final tempDir = await getTemporaryDirectory();
                          final tempFile = File(
                            '${tempDir.path}/post_story_${DateTime.now().millisecondsSinceEpoch}.png',
                          );
                          await tempFile.writeAsBytes(imageBytes);

                          if (context.mounted) {
                            context.pop();
                          }

                          if (context.mounted) {
                            await StoryPreviewRoute(
                              path: tempFile.path,
                              mimeType: 'image/png',
                              eventReference: eventReference.encode(),
                            ).push<void>(context);
                          }
                        } catch (e) {
                          Logger.error('Error capturing post screenshot: $e');
                          isCapturing.value = false;
                        }
                      },
              ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconBlockCopy1.icon(size: iconSize, color: Colors.black),
              label: context.i18n.feed_copy_link,
              onPressed: () {
                copyToClipboard(shareUrl);
                context.pop();
              },
            ),
            if (isPost)
              _ShareOptionsMenuItem(
                buttonType: ButtonType.dropdown,
                icon: Assets.svg.iconBookmarks.icon(size: iconSize, color: Colors.black),
                label: context.i18n.button_bookmark,
                onPressed: () async {
                  await ref
                      .read(feedBookmarksNotifierProvider().notifier)
                      .toggleBookmark(eventReference);
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedWhatsapp.icon(size: iconSize),
              label: context.i18n.feed_whatsapp,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedTelegram.icon(size: iconSize),
              label: context.i18n.feed_telegram,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconLoginXlogo.icon(size: iconSize),
              label: context.i18n.feed_x,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedMore.icon(size: iconSize),
              label: context.i18n.feed_more,
              onPressed: () {
                shareContent(shareUrl);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareOptionsMenuItem extends StatelessWidget {
  const _ShareOptionsMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.buttonType,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0.s,
      child: Column(
        children: [
          Button.icon(
            type: buttonType,
            onPressed: onPressed,
            icon: icon,
          ),
          SizedBox(height: 6.0.s),
          Text(
            label,
            style: context.theme.appTextThemes.caption2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
