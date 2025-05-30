// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/statistics/services/hashtags/hashtags_service.dart';

class IONIdentityStatistics {
  IONIdentityStatistics({
    required this.username,
    required HashtagsService hashtagsService,
  }) : _hashtagsService = hashtagsService;

  final String username;
  final HashtagsService _hashtagsService;

  Future<List<String>> getHashtags({
    required String query,
    required int limit,
  }) {
    return _hashtagsService.getHashtags(
      username: username,
      query: query,
      limit: limit,
    );
  }
}
