// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_wallets_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetWalletsResponseImpl _$$GetWalletsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetWalletsResponseImpl(
      username: json['username'] as String,
      paginationToken: json['paginationToken'] as String?,
    );

Map<String, dynamic> _$$GetWalletsResponseImplToJson(
    _$GetWalletsResponseImpl instance) {
  final val = <String, dynamic>{
    'username': instance.username,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('paginationToken', instance.paginationToken);
  return val;
}
