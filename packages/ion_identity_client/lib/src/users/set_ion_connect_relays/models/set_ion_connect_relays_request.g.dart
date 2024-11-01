// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_ion_connect_relays_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetIonConnectRelaysRequestImpl _$$SetIonConnectRelaysRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SetIonConnectRelaysRequestImpl(
      followeeList: (json['followeeList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SetIonConnectRelaysRequestImplToJson(
        _$SetIonConnectRelaysRequestImpl instance) =>
    <String, dynamic>{
      'followeeList': instance.followeeList,
    };
