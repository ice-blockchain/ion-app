// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';

List<String> extractTopics(List<RelatedHashtag>? relatedHashtags) {
  if (relatedHashtags == null || relatedHashtags.isEmpty) {
    return [];
  }
  final topicsHashtags = relatedHashtags.where((relatedHashtag) {
    return !RelatedHashtag.isTag(relatedHashtag.value);
  }).toList();

  if (topicsHashtags.isEmpty) {
    return [];
  }

  return topicsHashtags.map((relatedHashtag) => relatedHashtag.value).toList();
}
