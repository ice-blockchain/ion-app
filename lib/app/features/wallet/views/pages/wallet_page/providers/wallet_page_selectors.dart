import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/model/wallet_page_provider_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

bool walletTabSearchVisibleSelector(WidgetRef ref, WalletTabType tabType) {
  return ref.watch(
    walletPageNotifierProvider.select(
      (WalletPageProviderData data) =>
          data.tabSearchVisibleMap[tabType] ?? false,
    ),
  );
}
