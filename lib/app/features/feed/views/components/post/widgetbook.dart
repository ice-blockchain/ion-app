// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
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
            postId: '5f6556d1-9a5e-4092-a7e3-a202857b445f',
            pubkey: 'd0c01dd5931409d2bc7e58ee4908e6366ff0fd722d20e9c709fde6846f3ceabb',
          ),
          Post(
            postId: '430692:6',
            pubkey: '9d7d214c58fdc67b0884669abfd700cfd7c173b29a0c58ee29fb9506b8b64efa',
          ),
          Post(
            postId: '430692:16',
            pubkey: 'd84517802a434757c56ae8642bffb4d26e5ade0712053750215680f5896e579b',
          ),
        ],
      ),
    ),
  );
}
