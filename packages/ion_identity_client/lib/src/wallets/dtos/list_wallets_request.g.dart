// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_wallets_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListWalletsRequest _$ListWalletsRequestFromJson(Map<String, dynamic> json) =>
    ListWalletsRequest(
      username: json['username'] as String,
      paginationToken: json['paginationToken'] as String?,
    );

Map<String, dynamic> _$ListWalletsRequestToJson(ListWalletsRequest instance) {
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
