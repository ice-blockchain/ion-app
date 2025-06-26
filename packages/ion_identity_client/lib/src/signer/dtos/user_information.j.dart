// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_information.j.g.dart';

@JsonSerializable()
class UserInformation {
  const UserInformation(
    this.id,
    this.displayName,
    this.name,
  );

  factory UserInformation.fromJson(JsonObject json) => _$UserInformationFromJson(json);

  final String id;
  final String displayName;
  final String name;

  JsonObject toJson() => _$UserInformationToJson(this);

  @override
  String toString() => 'UserInformation(id: $id, displayName: $displayName, name: $name)';
}
