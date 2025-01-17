import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallet/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_wallet_view_provider.c.g.dart';

@riverpod
Future<void> updateWalletView(
  Ref ref, {
  required WalletViewData walletView,
  required String walletViewName,
}) async {
  final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return;
  }

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  final identity = ionIdentity(username: currentIdentityKeyName);

  final symbolGroups = <String>{};
  final walletViewItems = <WalletViewItem>[];

  for (final coinInWallet in walletView.coins) {
    final coin = coinInWallet.coin;

    symbolGroups.add(coin.symbolGroup);
    walletViewItems.add(
      WalletViewItem(
        coinId: coin.id,
        walletId: coinInWallet.walletId,
      ),
    );
  }

  await identity.wallets.updateWalletView(
    walletView.id,
    CreateUpdateWalletViewRequest(
      items: walletViewItems,
      symbolGroups: symbolGroups.toList(),
      name: walletViewName,
    ),
  );

  ref.invalidate(currentUserWalletViewsProvider);
}
