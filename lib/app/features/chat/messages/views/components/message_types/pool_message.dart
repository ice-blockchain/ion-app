// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';

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
            child: MessageTimeStamp(isMe: isMe),
          ),
        ],
      ),
    );
  }
}

class PollResultMessage extends StatelessWidget {
  const PollResultMessage({required this.isMe, super.key});
  final bool isMe;

  @override
  Widget build(BuildContext context) {
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

              final percentage = option.votes /
                  mockPoll.options.map((e) => e.votes).reduce((value, element) => value + element);
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 28.0.s,
                      borderRadius: BorderRadius.circular(12.0.s),
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isMe
                            ? context.theme.appColors.darkBlue
                            : context.theme.appColors.onTerararyFill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.0.s,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option.option,
                          style: context.theme.appTextThemes.caption2.copyWith(
                            color: isMe
                                ? context.theme.appColors.onPrimaryAccent
                                : context.theme.appColors.primaryText,
                          ),
                        ),
                        Text(
                          '${(percentage * 100).toInt()}%',
                          style: context.theme.appTextThemes.caption2.copyWith(
                            color: isMe
                                ? context.theme.appColors.onPrimaryAccent
                                : context.theme.appColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10.0.s),
            itemCount: mockPoll.options.length,
          ),
          SizedBox(height: 10.0.s),
          Text(
            'Votes: 2  •  Left: 1 day 2 hours',
            style: context.theme.appTextThemes.caption2.copyWith(
              color: isMe
                  ? context.theme.appColors.strokeElements
                  : context.theme.appColors.quaternaryText,
            ),
          ),
          SizedBox(height: 4.0.s),
          Align(
            alignment: Alignment.centerRight,
            child: MessageTimeStamp(isMe: isMe),
          ),
        ],
      ),
    );
  }
}

class Poll {
  Poll({required this.question, required this.options});
  final String question;
  final List<PollItem> options;
}

class PollItem {
  PollItem({
    required this.id,
    required this.option,
    required this.votes,
  });
  final String id;
  final String option;
  final int votes;
}

final mockPoll = Poll(
  question: 'What is your favorite color? 🌈. Also feel free to add your own options!',
  options: [
    PollItem(id: '1', option: 'Red', votes: 10),
    PollItem(id: '2', option: 'Blue', votes: 5),
    PollItem(id: '3', option: 'Green', votes: 3),
    PollItem(id: '4', option: 'Yellow', votes: 2),
  ],
);
