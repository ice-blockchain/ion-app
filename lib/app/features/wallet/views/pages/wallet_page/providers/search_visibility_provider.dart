import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_visibility_provider.g.dart';

@riverpod
class WalletSearchVisibility extends _$WalletSearchVisibility {
  @override
  bool build(WalletTabType tabType) => false;

  set isVisible(bool isVisible) => state = isVisible;
}
