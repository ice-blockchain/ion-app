// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'network.c.freezed.dart';
part 'network.c.g.dart';

@freezed
class Network with _$Network {
  const factory Network({
    required String displayName,
    required String explorerUrl,
    required String id,
    required String image,
    required bool isTestnet,
    @Default(1) int tier,
  }) = _Network;

  factory Network.fromJson(Map<String, dynamic> json) => _$NetworkFromJson(json);
}
