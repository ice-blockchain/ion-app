// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/users/get_content_creators/content_creators_service.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/set_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/user_details/user_details_service.dart';

class IONIdentityUsers {
  const IONIdentityUsers(
    this.username,
    this._getUserDetailsService,
    this._ionConnectIndexersService,
    this._setIONConnectRelaysService,
    this._ionConnectContentCreatorsService,
    this._extractUserIdService,
  );

  final String username;
  final UserDetailsService _getUserDetailsService;
  final IONConnectIndexersService _ionConnectIndexersService;
  final IONConnectContentCreatorsService _ionConnectContentCreatorsService;
  final SetIONConnectRelaysService _setIONConnectRelaysService;
  final ExtractUserIdService _extractUserIdService;

  Future<UserDetails> currentUserDetails() async {
    final userId = _extractUserIdService.extractUserId(username: username);
    return _getUserDetailsService.details(userId: userId);
  }

  Future<UserDetails> details({
    required String userId,
  }) async =>
      _getUserDetailsService.details(userId: userId);

  Future<List<String>> ionConnectIndexers({
    required String userId,
  }) async =>
      _ionConnectIndexersService.ionConnectIndexers(userId: userId);

  Future<SetIONConnectRelaysResponse> setIONConnectRelays({
    required List<String> followeeList,
  }) async {
    final userId = _extractUserIdService.extractUserId(username: username);
    return _setIONConnectRelaysService.setIONConnectRelays(
      userId: userId,
      followeeList: followeeList,
    );
  }

  Future<List<ContentCreatorResponseData>> getContentCreators({
    required int limit,
    required List<String> excludeMasterPubKeys,
  }) async {
    final userId = _extractUserIdService.extractUserId(username: username);
    return _ionConnectContentCreatorsService.contentCreators(
      limit: limit,
      userId: userId,
      excludeMasterPubKeys: excludeMasterPubKeys,
    );
  }
}
