// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_ion_connect_relays_request.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetIONConnectRelaysRequestImpl _$$SetIONConnectRelaysRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SetIONConnectRelaysRequestImpl(
      followeeList: (json['followeeList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SetIONConnectRelaysRequestImplToJson(
        _$SetIONConnectRelaysRequestImpl instance) =>
    <String, dynamic>{
      'followeeList': instance.followeeList,
    };
