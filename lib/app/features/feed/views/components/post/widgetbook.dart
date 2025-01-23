// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'feed post',
  type: Post,
)
Widget feedPostUseCase(BuildContext context) {
  return const Scaffold(
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Post(
            eventReference: ImmutableEventReference(
              eventId: 'ccfac3cb94d5d1190d5129c38e11ba6c02e76352fd884a3dd9357360b74d3cef',
              pubkey: '32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245',
            ),
          ),
          Post(
            eventReference: ImmutableEventReference(
              eventId: 'c429025124ee136c1bcb11fcd2ff905c84a0f946759cc39f336c4b296db7a4ba',
              pubkey: 'd3f94b353542a632962062f3c914638d0deeba64af1f980d93907ee1b3e0d4f9',
            ),
          ),
          Post(
            eventReference: ImmutableEventReference(
              eventId: 'ef5b8e58a3edfe759250927e1c16e22a06cc32c8794f66882a4c0fea01038d2b',
              pubkey: '19e3eb646d228812b1cff08c505ea2ee5a85d34c567e42f47b3b32658e377fe1',
            ),
          ),
        ],
      ),
    ),
  );
}
