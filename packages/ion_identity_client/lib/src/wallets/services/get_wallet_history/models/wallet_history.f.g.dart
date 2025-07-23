// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_history.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletHistoryImpl _$$WalletHistoryImplFromJson(Map<String, dynamic> json) =>
    _$WalletHistoryImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => WalletHistoryRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$$WalletHistoryImplToJson(_$WalletHistoryImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      if (instance.nextPageToken case final value?) 'nextPageToken': value,
    };
