// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class NothingIsFound extends StatelessWidget {
  const NothingIsFound({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        child: EmptyList(
          asset: Assets.svg.walletIconWalletEmptysearch,
          title: title,
        ),
      ),
    );
  }
}
