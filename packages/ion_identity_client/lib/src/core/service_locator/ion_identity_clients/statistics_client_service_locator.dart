// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/statistics/ion_identity_statistics.dart';
import 'package:ion_identity_client/src/statistics/services/hashtags/data_sources/hashtags_data_source.dart';
import 'package:ion_identity_client/src/statistics/services/hashtags/hashtags_service.dart';

class StatisticsClientServiceLocator {
  factory StatisticsClientServiceLocator() {
    return _instance;
  }

  StatisticsClientServiceLocator._internal();

  static final StatisticsClientServiceLocator _instance =
      StatisticsClientServiceLocator._internal();

  IONIdentityStatistics statistics({
    required String username,
    required IONIdentityConfig config,
  }) {
    return IONIdentityStatistics(
      username: username,
      hashtagsService: hashtags(username: username, config: config),
    );
  }

  HashtagsService hashtags({
    required String username,
    required IONIdentityConfig config,
  }) {
    return HashtagsService(
      hashtagsDataSource: HashtagsDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
        tokenStorage: IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }
}
