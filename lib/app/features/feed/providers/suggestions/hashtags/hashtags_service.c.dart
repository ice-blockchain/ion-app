// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtags_service.c.g.dart';

@riverpod
Future<HashtagsService> hashtagsService(Ref ref) async {
  return HashtagsService(
    await ref.watch(ionIdentityClientProvider.future),
  );
}

class HashtagsService {
  HashtagsService(
    this._ionIdentityClient,
  );

  final IONIdentityClient _ionIdentityClient;

  Future<List<String>> getHashtags(String query, {int limit = 10}) =>
      _ionIdentityClient.statistics.getHashtags(
        query: query,
        limit: limit,
      );
}
