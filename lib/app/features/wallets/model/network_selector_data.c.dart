import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';

part 'network_selector_data.c.freezed.dart';

@freezed
class NetworkSelectorData with _$NetworkSelectorData {
  const factory NetworkSelectorData({
    required NetworkData selected,
    required List<NetworkData> availableNetworks,
  }) = _NetworkSelectorData;
}
