import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_query_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletSearchQueryController extends _$WalletSearchQueryController {
  @override
  String build(WalletAssetType assetType) => '';

  void update({required String query}) => state = query;
}
