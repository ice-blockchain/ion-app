// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_keys_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListKeysResponseImpl _$$ListKeysResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ListKeysResponseImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => KeyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$$ListKeysResponseImplToJson(
        _$ListKeysResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextPageToken': instance.nextPageToken,
    };
