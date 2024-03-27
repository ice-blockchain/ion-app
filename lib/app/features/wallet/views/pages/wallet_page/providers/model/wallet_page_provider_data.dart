import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

part 'wallet_page_provider_data.freezed.dart';

@Freezed(copyWith: true)
class WalletPageProviderData with _$WalletPageProviderData {
  const factory WalletPageProviderData({
    required Map<WalletTabType, bool> tabSearchVisibleMap,
    required Map<WalletTabType, String> assetSearchValues,
  }) = _WalletPageProviderData;
}
