// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'relying_party.j.g.dart';

@JsonSerializable()
class RelyingParty {
  RelyingParty(this.id, this.name);

  factory RelyingParty.fromJson(JsonObject json) {
    return _$RelyingPartyFromJson(json);
  }

  final String id;
  final String name;

  JsonObject toJson() => _$RelyingPartyToJson(this);
}
