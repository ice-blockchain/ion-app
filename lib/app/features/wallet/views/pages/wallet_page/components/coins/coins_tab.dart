import 'package:flutter/material.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class CoinsTab extends StatelessWidget {
  const CoinsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      tabType: WalletTabType.coins,
    );
  }
}
