import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';

class TextMessageLimitLabel extends HookWidget {
  const TextMessageLimitLabel({
    required this.textEditingController,
    super.key,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final exceededLimit = useState<int>(0);

    useEffect(
      () {
        void onTextChanged() {
          exceededLimit.value =
              textEditingController.text.length - PrivateDirectMessageData.textMessageLimit;
        }

        textEditingController.addListener(onTextChanged);
        return () => textEditingController.removeListener(onTextChanged);
      },
      [textEditingController],
    );

    if (exceededLimit.value > 0) {
      return Positioned(
        top: 8.0.s,
        right: 15.0.s,
        child: Text(
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.attentionRed,
          ),
          '-$exceededLimit',
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
