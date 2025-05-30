// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'derive_request.c.freezed.dart';
part 'derive_request.c.g.dart';

@freezed
class DeriveRequest with _$DeriveRequest {
  factory DeriveRequest({
    required String domain,
    required String seed,
  }) = _DeriveRequest;

  factory DeriveRequest.fromJson(Map<String, dynamic> json) => _$DeriveRequestFromJson(json);
}
