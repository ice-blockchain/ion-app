import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyList(
        asset: Assets.svg.walletIconProfileEmptyprofile,
        title: context.i18n.notifications_empty_state,
      ),
    );
  }
}
