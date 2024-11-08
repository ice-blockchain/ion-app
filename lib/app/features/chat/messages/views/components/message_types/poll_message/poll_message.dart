// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/poll_message/mock.dart';

part 'poll_result_message.dart';

class PollMessage extends HookWidget {
  const PollMessage({required this.isMe, super.key});
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final selectedId = useState<String?>(null);

    if (selectedId.value != null) {
      return PollResultMessage(isMe: isMe);
    }

    return MessageItemWrapper(
      contentPadding: EdgeInsets.all(
        12.0.s,
      ),
      isMe: isMe,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              mockPoll.question,
              style: context.theme.appTextThemes.body2.copyWith(
                color: isMe
                    ? context.theme.appColors.onPrimaryAccent
                    : context.theme.appColors.primaryText,
              ),
            ),
          ),
          SizedBox(height: 10.0.s),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final option = mockPoll.options[index];
              return Button.compact(
                type: ButtonType.outlined,
                backgroundColor: context.theme.appColors.tertararyBackground,
                label: Text(
                  option.option,
                  style: context.theme.appTextThemes.caption2
                      .copyWith(color: context.theme.appColors.primaryText),
                ),
                onPressed: () {
                  selectedId.value = option.id;
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10.0.s),
            itemCount: mockPoll.options.length,
          ),
          SizedBox(height: 4.0.s),
          Align(
            alignment: Alignment.centerRight,
            child: MessageMetaData(isMe: isMe),
          ),
        ],
      ),
    );
  }
}
