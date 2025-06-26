// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'disliked_relay_urls_collection.f.freezed.dart';

@freezed
class DislikedRelayUrlsCollection with _$DislikedRelayUrlsCollection {
  const factory DislikedRelayUrlsCollection(
    Set<String> urls,
  ) = _DislikedRelayUrlsCollection;

  const DislikedRelayUrlsCollection._();

  bool contains(String url) {
    return urls.contains(url);
  }
}
