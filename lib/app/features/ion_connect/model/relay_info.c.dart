import 'package:freezed_annotation/freezed_annotation.dart';

part 'relay_info.c.freezed.dart';
part 'relay_info.c.g.dart';

/// https://github.com/nostr-protocol/nips/blob/master/11.md
@freezed
class RelayInfo with _$RelayInfo {
  const factory RelayInfo({
    required String name,
    required String description,
    required String banner,
    required String icon,
    required String pubkey,
    required String contact,
    required List<int> supportedNips,
    required String software,
    required String version,
    required String privacyPolicy,
    required String termsOfService,
    required List<RelayFcmConfig> fcmAndroidConfigs,
    required List<RelayFcmConfig> fcmIosConfigs,
    required List<RelayFcmConfig> fcmWebConfigs,
  }) = _RelayInfo;

  factory RelayInfo.fromJson(Map<String, dynamic> json) => _$RelayInfoFromJson(json);
}

/// https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-8000.md#fcm-client-configuration
@freezed
class RelayFcmConfig with _$RelayFcmConfig {
  const factory RelayFcmConfig({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) = _RelayFcmConfig;

  factory RelayFcmConfig.fromJson(Map<String, dynamic> json) => _$RelayFcmConfigFromJson(json);
}
