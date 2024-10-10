import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/result_types/get_wallet_assets_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_assets_provider.g.dart';

@riverpod
Future<GetWalletAssetsResult> walletAssets(WalletAssetsRef ref, String walletId) async {
  final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';
  final ionClient = await ref.watch(ionClientProvider.future);

  return ionClient(username: username).wallets.walletAssets(walletId);
}
