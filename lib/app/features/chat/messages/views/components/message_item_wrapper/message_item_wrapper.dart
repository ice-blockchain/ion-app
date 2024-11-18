import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_seperator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/recent_emoji_reactions_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageItemWrapper extends HookWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.contentPadding,
    super.key,
  });
  final bool isMe;
  final Widget child;
  final EdgeInsetsGeometry contentPadding;

  static double get maxWidth => 282.0.s;

  @override
  Widget build(BuildContext context) {
    final containerKey = useMemoized(GlobalKey.new);

    Future<void> captureAndShowImage() async {
      try {
        final renderObject = containerKey.currentContext?.findRenderObject();
        if (renderObject is RenderRepaintBoundary) {
          final image = renderObject.toImageSync(pixelRatio: 3);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final imageBytes = byteData.buffer.asUint8List();
            final box = renderObject as RenderBox;
            final position = box.localToGlobal(Offset.zero);
            final size = box.size;

            if (context.mounted) {
              await showDialog<void>(
                context: context,
                barrierColor: Colors.transparent,
                useSafeArea: false,
                builder: (context) => ReactDialog(
                  isMe: isMe,
                  imageBytes: imageBytes,
                  position: position,
                  size: size,
                ),
              );
            }
          }
        } else {
          if (kDebugMode) {
            print('Error: RenderObject is not a RepaintBoundary');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error capturing widget as image: $e');
        }
      }
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          captureAndShowImage();
        },
        child: ScreenSideOffset.small(
          child: RepaintBoundary(
            key: containerKey,
            child: Container(
              padding: contentPadding,
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors.onPrimaryAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.s),
                  topRight: Radius.circular(20.0.s),
                  bottomLeft: isMe ? Radius.circular(20.0.s) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : Radius.circular(20.0.s),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ReactDialog extends StatelessWidget {
  const ReactDialog({
    required this.imageBytes,
    required this.position,
    required this.size,
    required this.isMe,
    super.key,
  });
  final Uint8List imageBytes;
  final Offset position;
  final Size size;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    final emojiSectionHeight = 72.0.s;
    final contextMenuHeight = 237.0.s;
    final availableHeight = MediaQuery.sizeOf(context).height -
        emojiSectionHeight -
        contextMenuHeight -
        MediaQuery.paddingOf(context).bottom -
        MediaQuery.paddingOf(context).top;

    final contentHeight = min(size.height, availableHeight);
    final isHugeComponent = size.height > availableHeight;

    final bottomdY = position.dy + size.height;

    final overflowBottomSize = MediaQuery.sizeOf(context).height -
        // bottomdY -
        (position.dy > 0 ? (isHugeComponent ? 0 : bottomdY) : bottomdY) -
        contextMenuHeight -
        MediaQuery.paddingOf(context).bottom;

    print('overflowBottomSize: $overflowBottomSize');

    final topY = isHugeComponent
        ? null
        : overflowBottomSize < 0
            ? null
            : position.dy - emojiSectionHeight;

    print('topY: $topY');

    return Stack(
      children: [
        // Blurred background
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),
        Positioned(
          left: isMe ? null : 16.0.s,
          right: isMe ? 16.0.s : null,
          // top: overflowBottomSize < 0 ? null : position.dy - emojiSectionHeight
          top: topY,
          bottom: overflowBottomSize < 0
              ? MediaQuery.paddingOf(context).bottom
              : MediaQuery.paddingOf(context).bottom,
          // top: position.dy,
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              EmojiBar(emojiSectionHeight: emojiSectionHeight, isMe: isMe),
              Image.memory(
                height: contentHeight,
                fit: BoxFit.fitHeight,
                imageBytes,
              ),
              //mock context menu
              const ReactionOverlayMenu(),
            ],
          ),
        ),
      ],
    );
  }
}

class EmojiBar extends ConsumerWidget {
  const EmojiBar({
    required this.emojiSectionHeight,
    required this.isMe,
    super.key,
  });

  final double emojiSectionHeight;
  final bool isMe;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentEmojiReactions = ref.watch(recentEmojiReactionsProvider);

    return SizedBox(
      height: emojiSectionHeight,
      width: MediaQuery.sizeOf(context).width - 32.0.s,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.onPrimaryAccent,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
            padding: EdgeInsets.all(12.0.s),
            child: Row(
              children: [
                Row(
                  children: recentEmojiReactions.map(
                    (emoji) {
                      return GestureDetector(
                        onTap: () {
                          ref.read(recentEmojiReactionsProvider.notifier).addEmoji(emoji);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0.s, horizontal: 10.0.s),
                          margin: EdgeInsets.only(right: 14.0.s),
                          decoration: BoxDecoration(
                            color: context.theme.appColors.primaryBackground,
                            borderRadius: BorderRadius.circular(20.0.s),
                          ),
                          child: Text(
                            emoji,
                            style: context.theme.appTextThemes.title.copyWith(height: 1),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0.s, horizontal: 9.0.s),
                    decoration: BoxDecoration(
                      color: context.theme.appColors.primaryBackground,
                      borderRadius: BorderRadius.circular(20.0.s),
                    ),
                    child: Assets.svg.iconPostAddanswer.icon(
                      size: 20.0.s,
                      color: context.theme.appColors.primaryAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: Assets.svg.iconBubleCorner.iconWithDimensions(width: 20.0.s, height: 14.0.s),
          ),
        ],
      ),
    );
  }
}

class ReactionOverlayMenu extends StatelessWidget {
  const ReactionOverlayMenu({super.key});

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 237.0.s,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0.s),
        child: OverlayMenuContainer(
          child: IntrinsicWidth(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.s),
              child: Column(
                children: [
                  OverlayMenuItem(
                    label: context.i18n.button_reply,
                    //TODO: update when design is ready
                    icon: Assets.svg.iconChatReplymessage.icon(
                      size: iconSize,
                      color: context.theme.appColors.quaternaryText,
                    ),
                    onPressed: () {},
                    verticalPadding: 12,
                    minWidth: 140,
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_forward,
                    verticalPadding: 12,
                    icon: Assets.svg.iconFeedReplies
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {},
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_copy,
                    verticalPadding: 12,
                    icon: Assets.svg.iconBlockCopyBlue
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {},
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_bookmark,
                    verticalPadding: 12,
                    icon: Assets.svg.iconBookmarks
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {},
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_delete,
                    labelColor: context.theme.appColors.attentionRed,
                    verticalPadding: 12,
                    icon: Assets.svg.iconBlockDelete
                        .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
