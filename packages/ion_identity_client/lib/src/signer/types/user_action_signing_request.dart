// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_signing_init_request.f.dart';

class UserActionSigningRequest {
  const UserActionSigningRequest({
    required this.username,
    required this.method,
    required this.path,
    required this.body,
  });

  final String username;
  final HttpMethod method;
  final String path;
  final JsonObject body;

  UserActionSigningInitRequest get initRequest => UserActionSigningInitRequest(
        userActionPayload: jsonEncode(body),
        userActionHttpMethod: method.value,
        userActionHttpPath: path,
      );
}
