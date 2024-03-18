import 'package:flutter/material.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.tabType,
  });

  final WalletTabType tabType;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ScreenSideOffset.small(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: EmptyList(
                asset: tabType.emptyListAsset,
                title: tabType.getEmptyListTitle(context),
              ),
            ),
            BottomAction(
              asset: tabType.bottomActionAsset,
              title: tabType.getBottomActionTitle(context),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
