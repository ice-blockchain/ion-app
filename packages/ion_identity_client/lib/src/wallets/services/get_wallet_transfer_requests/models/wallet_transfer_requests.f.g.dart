// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transfer_requests.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletTransferRequestsImpl _$$WalletTransferRequestsImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletTransferRequestsImpl(
      walletId: json['walletId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => WalletTransferRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$$WalletTransferRequestsImplToJson(
        _$WalletTransferRequestsImpl instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextPageToken': instance.nextPageToken,
    };
