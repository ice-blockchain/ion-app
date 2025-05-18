// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_creator_response_data.c.freezed.dart';
part 'content_creator_response_data.c.g.dart';

@freezed
class ContentCreatorResponseData with _$ContentCreatorResponseData {
  const factory ContentCreatorResponseData({
    required String masterPubKey,
    required List<String> ionConnectRelays,
  }) = _ContentCreatorResponseData;

  factory ContentCreatorResponseData.fromJson(Map<String, dynamic> json) =>
      _$ContentCreatorResponseDataFromJson(json);
}
