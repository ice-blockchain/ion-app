// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';

class TextMessageLimitLabel extends HookConsumerWidget {
  const TextMessageLimitLabel({
    required this.textEditingController,
    super.key,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final exceededLimit = useState<int>(0);

    useEffect(
      () {
        void onTextChanged() {
          exceededLimit.value = textEditingController.text.length -
              ReplaceablePrivateDirectMessageData.textMessageLimit;
        }

        textEditingController.addListener(onTextChanged);
        return () => textEditingController.removeListener(onTextChanged);
      },
      [textEditingController],
    );

    if (exceededLimit.value > 0 && bottomBarState.isHasText) {
      return PositionedDirectional(
        top: 8.0.s,
        end: 15.0.s,
        child: Text(
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.attentionRed,
          ),
          '-${exceededLimit.value}',
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
