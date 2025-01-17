// SPDX-License-Identifier: ice License 1.0

import 'package:json_annotation/json_annotation.dart';

part 'private_key_data.c.g.dart';

@JsonSerializable()
class PrivateKeyData {
  PrivateKeyData({
    this.hexEncodedPrivateKeyBytes,
  });

  factory PrivateKeyData.fromJson(Map<String, dynamic> json) => _$PrivateKeyDataFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateKeyDataToJson(this);

  final String? hexEncodedPrivateKeyBytes;
}
