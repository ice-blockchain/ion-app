// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'requester.c.freezed.dart';
part 'requester.c.g.dart';

@freezed
class Requester with _$Requester {
  const factory Requester({
    required String userId,
    required String? tokenId,
    required String appId,
  }) = _Requester;

  factory Requester.fromJson(Map<String, dynamic> json) => _$RequesterFromJson(json);
}