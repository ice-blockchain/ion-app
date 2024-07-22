import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';

part 'send_nft_form_data.freezed.dart';

@Freezed(copyWith: true)
class SendNftFormData with _$SendNftFormData {
  const factory SendNftFormData({
    required NftData selectedNft,
    required NetworkType selectedNetwork,
    required String address,
    required int arrivalTime,
  }) = _SendNftFormData;
}
