// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_content.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class VisualMediaCustomGrid extends HookConsumerWidget {
  const VisualMediaCustomGrid({
    required this.messageMedias,
    required this.eventMessage,
    super.key,
  });

  static double height1 = 146.0.s;
  static double height2 = 110.0.s;
  static double height3 = 80.0.s;

  final List<MessageMediaTableData> messageMedias;
  final EventMessage eventMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaCount = messageMedias.length;

    if (mediaCount == 1) {
      return VisualMediaContent(
        messageMediaTableData: messageMedias.first,
        eventMessage: eventMessage,
        height: height1,
      );
    }

    if (mediaCount == 2) {
      return Row(
        children: [
          Expanded(
            child: VisualMediaContent(
              messageMediaTableData: messageMedias.first,
              eventMessage: eventMessage,
              height: height1,
            ),
          ),
          SizedBox(width: 4.0.s),
          Expanded(
            child: VisualMediaContent(
              messageMediaTableData: messageMedias.last,
              eventMessage: eventMessage,
              height: height1,
            ),
          ),
        ],
      );
    }

    if (mediaCount == 3) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 4) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 5) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[4],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 6) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[4],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[5],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 7) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[4],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[5],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[6],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 8) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[4],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[5],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[6],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[7],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 9) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[4],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[5],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[6],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[7],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[8],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (mediaCount == 10) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[0],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[1],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[2],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[3],
                  eventMessage: eventMessage,
                  height: height3,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[4],
                  eventMessage: eventMessage,
                  height: height3,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[5],
                  eventMessage: eventMessage,
                  height: height3,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[6],
                  eventMessage: eventMessage,
                  height: height3,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Row(
            children: <Widget>[
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[7],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[8],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
              SizedBox(width: 4.0.s),
              Expanded(
                child: VisualMediaContent(
                  messageMediaTableData: messageMedias[9],
                  eventMessage: eventMessage,
                  height: height2,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Container();
  }
}
