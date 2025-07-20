import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/attach_menu_shown_notifier.r.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/chat_attach_menu.dart';
import 'package:ion/generated/assets.gen.dart';

const nenuHeight = 264.0;

class ChatInputBar extends HookConsumerWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldFocusNode = useFocusNode();
    final textFieldController = useTextEditingController();

    final isAttachMenuShown = ref.watch(attachMenuShownProvider);
    final isActionButtonsProcessing = useRef(false);
    final isKeyboardVisible = useState(false);

    final cachePadding = useState<double>(0);

    useEffect(
      () {
        final subscription = KeyboardVisibilityController().onChange.listen((visible) {
          isKeyboardVisible.value = visible;
        });
        return subscription.cancel;
      },
      [],
    );

    //listen focus node changes
    useEffect(
      () {
        void listener() {
          if (isActionButtonsProcessing.value) return;

          if (textFieldFocusNode.hasFocus) {
            if (isAttachMenuShown) {
              ref.read(attachMenuShownProvider.notifier).hide();
            }
          } else {
            if (isKeyboardVisible.value) {
              cachePadding.value = 0;
              ref.read(attachMenuShownProvider.notifier).hide();
            }
          }
        }

        textFieldFocusNode.addListener(listener);
        return () => textFieldFocusNode.removeListener(listener);
      },
      [textFieldFocusNode, isAttachMenuShown, isKeyboardVisible.value, isActionButtonsProcessing],
    );

    final bottomPadding = useMemoized(
      () {
        return max(
          MediaQuery.viewInsetsOf(context).bottom - MediaQuery.viewPaddingOf(context).bottom,
          0,
        ).toDouble();
      },
      [MediaQuery.viewInsetsOf(context).bottom, MediaQuery.viewPaddingOf(context).bottom],
    );

    final showAttachMenu = useCallback(
      () {
        if (isAttachMenuShown) return;

        textFieldFocusNode.unfocus();
        cachePadding.value = bottomPadding;
        ref.read(attachMenuShownProvider.notifier).show();
      },
      [isAttachMenuShown, textFieldFocusNode, bottomPadding],
    );

    final hideAttachMenu = useCallback(
      () {
        if (!isAttachMenuShown) return;
        ref.read(attachMenuShownProvider.notifier).hide();
        textFieldFocusNode.requestFocus();

        Future<void>.delayed(const Duration(milliseconds: 600)).then((_) {
          if (!isAttachMenuShown) cachePadding.value = 0;
        });
      },
      [isAttachMenuShown, textFieldFocusNode],
    );

    final actualHeight = (cachePadding.value > 0
            ? cachePadding.value
            : bottomPadding > 0
                ? bottomPadding
                : isAttachMenuShown
                    ? moreContentHeight
                    : 0)
        .toDouble();

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 48.0.s,
          ),
          child: Row(
            children: [
              if (isAttachMenuShown)
                GestureDetector(
                  onTap: () async {
                    isActionButtonsProcessing.value = true;
                    hideAttachMenu();
                    await Future<void>.delayed(const Duration(milliseconds: 600));
                    isActionButtonsProcessing.value = false;
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.0.s),
                    child: Assets.svg.iconChatKeyboard.icon(
                      color: context.theme.appColors.primaryText,
                      size: 24.0.s,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () async {
                    isActionButtonsProcessing.value = true;
                    showAttachMenu();
                    await Future<void>.delayed(const Duration(milliseconds: 600));
                    isActionButtonsProcessing.value = false;
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.0.s),
                    child: Assets.svg.iconChatAttatch.icon(
                      color: context.theme.appColors.primaryText,
                      size: 24.0.s,
                    ),
                  ),
                ),
              SizedBox(width: 6.0.s),
              Expanded(
                child: TextFormField(
                  focusNode: textFieldFocusNode,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                  controller: textFieldController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 7.0.s,
                      horizontal: 12.0.s,
                    ),
                    fillColor: context.theme.appColors.onSecondaryBackground,
                    filled: true,
                    hintText: context.i18n.write_a_message,
                    hintStyle: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.quaternaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0.s),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: actualHeight,
          child: ChatAttachMenu(
            onSubmitted: ({content, mediaFiles}) {
              return Future.value();
            },
            receiverPubKey: '',
          ),
        ),
      ],
    );
  }
}
