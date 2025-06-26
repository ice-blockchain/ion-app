// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/related_pubkey.f.dart';

mixin EntityDataWithRelatedPubkeys {
  List<RelatedPubkey>? get relatedPubkeys;

  static List<RelatedPubkey>? fromTags(Map<String, List<List<String>>> tags) {
    return tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList();
  }
}
