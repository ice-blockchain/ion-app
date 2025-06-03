// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/verify_nickname_availability/data_sources/nickname_availability_data_source.dart';

class NicknameAvailabilityService {
  NicknameAvailabilityService(
    this.username,
    this._dataSource,
  );

  final String username;
  final NicknameAvailabilityDataSource _dataSource;

  Future<void> verifyNicknameAvailability({
    required String nickname,
  }) async =>
      _dataSource.verifyNicknameAvailability(
        username: username,
        nickname: nickname,
      );
}
