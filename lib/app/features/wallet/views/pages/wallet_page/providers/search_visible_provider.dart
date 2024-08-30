import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_visible_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletSearchVisibleController extends _$WalletSearchVisibleController {
  @override
  bool build(WalletTabType tabType) => false;

  void update({required bool isVisible}) => state = isVisible;
}
