// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/providers/search_visibility_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';

void cancelSearch(
  WidgetRef ref,
  WalletTabType tabType,
) {
  ref.read(walletSearchQueryControllerProvider(tabType.walletAssetType).notifier).query = '';
  ref.read(walletSearchVisibilityProvider(tabType).notifier).isVisible = false;
}
