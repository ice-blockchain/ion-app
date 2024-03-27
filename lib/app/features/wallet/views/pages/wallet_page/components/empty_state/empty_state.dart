import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/generated/assets.gen.dart';

class EmptyState extends HookConsumerWidget {
  const EmptyState({
    super.key,
    required this.tabType,
  });

  final WalletTabType tabType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String searchValue = walletAssetSearchValueSelector(ref, tabType);
    final bool toShowNoResults = searchValue.isNotEmpty == true;
    final AssetGenImage asset = toShowNoResults
        ? Assets.images.misc.emptySearch
        : tabType.emptyListAsset;
    final String title = toShowNoResults
        ? context.i18n.core_empty_search
        : tabType.getEmptyListTitle(context);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: ScreenSideOffset.small(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: EmptyList(
                asset: asset,
                title: title,
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
