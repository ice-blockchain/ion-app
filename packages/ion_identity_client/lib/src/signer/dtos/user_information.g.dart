// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformation _$UserInformationFromJson(Map<String, dynamic> json) =>
    UserInformation(
      json['id'] as String,
      json['displayName'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$UserInformationToJson(UserInformation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'name': instance.name,
    };
