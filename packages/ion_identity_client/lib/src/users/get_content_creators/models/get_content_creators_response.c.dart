// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/users/get_content_creators/models/content_creator_response_data.c.dart';

part 'get_content_creators_response.c.freezed.dart';
part 'get_content_creators_response.c.g.dart';

@freezed
class GetContentCreatorsResponse with _$GetContentCreatorsResponse {
  const factory GetContentCreatorsResponse(
    List<ContentCreatorResponseData> creators,
  ) = _GetContentCreatorsResponse;

  const GetContentCreatorsResponse._();

  factory GetContentCreatorsResponse.fromJson(List<dynamic> json) => GetContentCreatorsResponse(
        json.map((e) => ContentCreatorResponseData.fromJson(e as Map<String, dynamic>)).toList(),
      );
}
