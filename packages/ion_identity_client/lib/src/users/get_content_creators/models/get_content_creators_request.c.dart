// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_content_creators_request.c.freezed.dart';
part 'get_content_creators_request.c.g.dart';

@freezed
class GetContentCreatorsRequest with _$GetContentCreatorsRequest {
  const factory GetContentCreatorsRequest({
    required List<String> excludeMasterPubKeys,
  }) = _GetContentCreatorsRequest;

  factory GetContentCreatorsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetContentCreatorsRequestFromJson(json);
}
