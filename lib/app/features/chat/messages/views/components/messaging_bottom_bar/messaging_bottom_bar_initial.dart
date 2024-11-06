// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/generated/assets.gen.dart';

part './components/more_content_view/more_content_view.dart';

class BottomBarInitialView extends HookConsumerWidget {
  const BottomBarInitialView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final controllerFocusNode = useFocusNode();

    useEffect(
      () {
        void listener() {
          if (controller.text.isEmpty) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
          } else {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setHasText();
          }
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.addListener(listener);
        });
        return () => controller.removeListener(listener);
      },
      [],
    );

    useEffect(
      () {
        if (bottomBarState.isText) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            controller.clear();
            // await Future<void>.delayed(const Duration(milliseconds: 500));
            FocusScope.of(context).requestFocus(controllerFocusNode);
          });
        }
        return null;
      },
      [bottomBarState.isText],
    );

    return Column(
      children: [
        Container(
          color: context.theme.appColors.onPrimaryAccent,
          constraints: BoxConstraints(
            minHeight: 48.0.s,
          ),
          padding: EdgeInsets.fromLTRB(8.0.s, 8.0.s, 44.0.s, 8.0.s),
          child: Row(
            children: [
              if (bottomBarState.isMore)
                GestureDetector(
                  onTap: () async {
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
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
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future<void>.delayed(const Duration(milliseconds: 700));
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setMore();
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
                child: TextField(
                  controller: controller,
                  focusNode: controllerFocusNode,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                  onTap: () {
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  },
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 7.0.s,
                      horizontal: 12.0.s,
                    ),
                    fillColor: context.theme.appColors.onSecondaryBackground,
                    filled: true,
                    hintText: context.i18n.messaging_textfiled_placeholder,
                    hintStyle: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.quaternaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0.s),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) => controller.clear(),
                ),
              ),
              SizedBox(width: 6.0.s),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: bottomBarState.isHasText ? EdgeInsets.only(right: 4.0.s) : EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(4.0.s),
                  child: Assets.svg.iconCameraOpen.icon(
                    color: context.theme.appColors.primaryText,
                    size: 24.0.s,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (bottomBarState.isMore) const _MoreContentView(),
      ],
    );
  }
}
