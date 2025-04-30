// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_medias_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_reply_message_provider.c.dart';
import 'package:ion/app/features/chat/views/pages/chat_media_page/components/chat_media_context_menu.dart';
import 'package:ion/app/features/chat/views/pages/chat_media_page/components/chat_media_metadata.dart';
import 'package:ion/app/features/chat/views/pages/chat_media_page/components/chat_media_page_view.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/hooks/use_image_zoom.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatMediaPage extends HookConsumerWidget {
  const ChatMediaPage({
    required this.eventMessageId,
    required this.initialIndex,
    super.key,
  });

  final String eventMessageId;
  final int initialIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStatusBarColor();
    final currentPage = useState(initialIndex);
    final messageDetailsKey = useRef(GlobalKey());
    final bottomHeight = useState<double>(0);

    final pageController = usePageController(initialPage: initialIndex);
    final zoomController = useImageZoom(ref, withReset: true);

    useEffect(
      () {
        void listener() {
          if (pageController.hasClients && pageController.page != null) {
            final newPage = pageController.page!.round();
            if (newPage != currentPage.value) {
              currentPage.value = newPage;
              zoomController.resetZoom?.call();
            }
          }
        }

        pageController.addListener(listener);

        return () {
          if (pageController.hasClients) {
            pageController.removeListener(listener);
          }
        };
      },
      [pageController, zoomController],
    );

    final isZoomed = ref.watch(imageZoomProvider);

    final eventMessageFuture = useFuture(
      useMemoized(
        () => ref.watch(eventMessageDaoProvider).getById(eventMessageId),
        [eventMessageId],
      ),
    );

    if (!eventMessageFuture.hasData) {
      return const SizedBox.shrink();
    }
    final eventMessage = eventMessageFuture.data!;
    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    final medias = ref.watch(chatMediasProvider(eventMessageId: eventMessageId)).valueOrNull;

    useOnInit(
      () {
        final context = messageDetailsKey.value.currentContext;
        if (context != null && context.mounted) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            bottomHeight.value = box.size.height;
          }
        }
        return;
      },
      [medias],
    );

    if (medias == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: context.theme.appColors.primaryText,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: context.theme.appColors.primaryText,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: context.theme.appColors.primaryText,
          extendBodyBehindAppBar: true,
          appBar: NavigationAppBar.screen(
            backgroundColor: Colors.transparent,
            leading: NavigationBackButton(
              () => context.pop(),
              icon: Assets.svg.iconChatBack.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.onPrimaryAccent,
                flipForRtl: true,
              ),
            ),
            onBackPress: () => context.pop(),
            actions: const [
              ChatMediaContextMenu(),
            ],
            title: _MediaPagerCounter(
              currentPage: currentPage.value,
              totalPages: medias.length,
            ),
          ),
          body: Stack(
            children: [
              ChatMediaPageView(
                medias: medias,
                entity: entity,
                bottomHeight: bottomHeight.value,
                initialIndex: initialIndex,
                zoomController: zoomController,
                isZoomed: isZoomed,
                pageController: pageController,
              ),
              _MediaBottomOverlay(
                eventMessage: eventMessage,
                messageDetailsKey: messageDetailsKey.value,
                messageMedias: medias,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaPagerCounter extends StatelessWidget {
  const _MediaPagerCounter({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${currentPage + 1}/$totalPages',
      style: context.theme.appTextThemes.subtitle2.copyWith(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}

class _MediaBottomOverlay extends ConsumerWidget {
  const _MediaBottomOverlay({
    required this.eventMessage,
    required this.messageDetailsKey,
    required this.messageMedias,
  });

  final EventMessage eventMessage;
  final GlobalKey messageDetailsKey;
  final List<MessageMediaTableData> messageMedias;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositionedDirectional(
      bottom: MediaQuery.paddingOf(context).bottom,
      start: 0,
      end: 0,
      child: ScreenSideOffset.small(
        key: messageDetailsKey,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 8.0.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eventMessage.content.isNotEmpty)
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 24.0.s),
                  child: Text(
                    eventMessage.content,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChatMediaMetaData(
                    eventMessage: eventMessage,
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(selectedReplyMessageProvider.notifier).selectedReplyMessage = MediaItem(
                        medias: messageMedias,
                        eventMessage: eventMessage,
                        contentDescription: context.i18n.common_media,
                      );
                      context.pop();
                    },
                    child: Assets.svg.iconChatReplymessage.icon(
                      size: 20.0.s,
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
