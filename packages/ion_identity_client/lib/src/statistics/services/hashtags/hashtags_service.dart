// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/statistics/services/hashtags/data_sources/hashtags_data_source.dart';

class HashtagsService {
  HashtagsService({
    required HashtagsDataSource hashtagsDataSource,
  }) : _hashtagsDataSource = hashtagsDataSource;

  final HashtagsDataSource _hashtagsDataSource;

  Future<List<String>> getHashtags({
    required String username,
    required String query,
    required int limit,
  }) {
    return _hashtagsDataSource.getHashtags(
      username: username,
      query: query,
      limit: limit,
    );
  }
}
