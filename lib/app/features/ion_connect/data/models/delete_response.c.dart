// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_response.c.freezed.dart';
part 'delete_response.c.g.dart';

@freezed
class DeleteResponse with _$DeleteResponse {
  const factory DeleteResponse({
    required String status,
    required String message,
  }) = _DeleteResponse;

  factory DeleteResponse.fromJson(Map<String, dynamic> json) => _$DeleteResponseFromJson(json);
}
