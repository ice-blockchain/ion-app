// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSearchNoResults extends StatelessWidget {
  const ChatSearchNoResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.s),
      child: EmptyList(
        asset: Assets.svgWalletIconWalletEmptysearch,
        title: context.i18n.core_empty_search,
      ),
    );
  }
}
