// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/users/available_ion_connect_relays/available_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/get_content_creators/content_creators_service.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/set_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/update_user_social_profile/update_user_social_profile_service.dart';
import 'package:ion_identity_client/src/users/user_details/user_details_service.dart';
import 'package:ion_identity_client/src/users/verify_nickname_availability/nickname_availability_service.dart';

class IONIdentityUsers {
  const IONIdentityUsers(
    this.username,
    this._getUserDetailsService,
    this._ionConnectIndexersService,
    this._setIONConnectRelaysService,
    this._ionConnectContentCreatorsService,
    this._nicknameAvailabilityService,
    this._updateUserSocialProfileService,
    this._extractUserIdService,
    this._availableIONConnectRelaysService,
  );

  final String username;
  final UserDetailsService _getUserDetailsService;
  final IONConnectIndexersService _ionConnectIndexersService;
  final IONConnectContentCreatorsService _ionConnectContentCreatorsService;
  final NicknameAvailabilityService _nicknameAvailabilityService;
  final SetIONConnectRelaysService _setIONConnectRelaysService;
  final UpdateUserSocialProfileService _updateUserSocialProfileService;
  final ExtractUserIdService _extractUserIdService;
  final AvailableIONConnectRelaysService _availableIONConnectRelaysService;

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
    return _ionConnectContentCreatorsService.contentCreators(
      limit: limit,
      excludeMasterPubKeys: excludeMasterPubKeys,
    );
  }

  Future<List<String>> availableIonConnectRelays({
    required String relayUrl,
  }) async {
    final userId = _extractUserIdService.extractUserId(username: username);
    return _availableIONConnectRelaysService.allAvailableIonConnectRelays(
      userId: userId,
      relayUrl: relayUrl,
    );
  }

  Future<void> verifyNicknameAvailability({
    required String nickname,
  }) =>
      _nicknameAvailabilityService.verifyNicknameAvailability(
        nickname: nickname,
      );

  Future<List<Map<String, dynamic>>> updateUserSocialProfile({
    required UserSocialProfileData data,
  }) async {
    final userId = _extractUserIdService.extractUserId(username: username);
    return _updateUserSocialProfileService.updateUserSocialProfile(
      userId: userId,
      data: data,
    );
  }
}
