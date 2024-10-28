// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_user_connect_relays_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetUserConnectRelaysRequestImpl _$$SetUserConnectRelaysRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SetUserConnectRelaysRequestImpl(
      followeeList: (json['followeeList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SetUserConnectRelaysRequestImplToJson(
        _$SetUserConnectRelaysRequestImpl instance) =>
    <String, dynamic>{
      'followeeList': instance.followeeList,
    };
