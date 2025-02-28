// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';

abstract class SearchExtension {
  String get query;

  @override
  String toString() => query;
}

abstract class IncludeSearchExtension extends SearchExtension {
  int get forKind;

  @override
  String toString() => 'include:dependencies:kind$forKind>$query';
}

class SearchExtensions {
  SearchExtensions(this.extensions);

  factory SearchExtensions.withCounters(
    List<SearchExtension> extensions, {
    required String currentPubkey,
    int forKind = ModifiablePostEntity.kind,
    bool root = true,
  }) {
    return SearchExtensions([
      RepliesCountSearchExtension(root: root, forKind: forKind),
      GenericRepostsCountSearchExtension(forKind: forKind),
      QuotesCountSearchExtension(forKind: forKind),
      ReactionsCountSearchExtension(forKind: forKind),
      ReplySampleSearchExtension(currentPubkey: currentPubkey, root: root, forKind: forKind),
      GenericRepostSampleSearchExtension(currentPubkey: currentPubkey, forKind: forKind),
      ReactionsSearchExtension(currentPubkey: currentPubkey, forKind: forKind),
      ...extensions,
    ]);
  }

  final List<SearchExtension> extensions;

  @override
  String toString() => extensions.join(' ');
}

class DiscoveryCreatorsSearchExtension extends SearchExtension {
  @override
  final String query = 'discover content creators to follow';
}

class MostRelevantFollowersSearchExtension extends SearchExtension {
  @override
  final String query = 'most relevant followers';
}

class TrendingSearchExtension extends SearchExtension {
  @override
  final String query = 'trending';
}

class TopSearchExtension extends SearchExtension {
  @override
  final String query = 'top';
}

/// For every kind [forKind] that the subscription finds also include the count of replies that it has
class RepliesCountSearchExtension extends IncludeSearchExtension {
  RepliesCountSearchExtension({this.root = true, this.forKind = ModifiablePostEntity.kind});

  final bool root;

  @override
  final int forKind;

  @override
  String get query => 'kind6400+kind30175+group+${root ? 'root' : 'reply'}';
}

/// For every kind [ModifiablePostEntity.kind] that the subscription finds also include the count of reposts that it has
class RepostsCountSearchExtension extends IncludeSearchExtension {
  @override
  int get forKind => PostEntity.kind;

  @override
  final String query = 'kind6400+kind6+group+e';
}

/// For every kind [forKind] that the subscription finds also include the count of generic reposts that it has
class GenericRepostsCountSearchExtension extends IncludeSearchExtension {
  GenericRepostsCountSearchExtension({this.forKind = ModifiablePostEntity.kind});

  @override
  final int forKind;

  @override
  final String query = 'kind6400+kind16+group+e';
}

/// For every kind [forKind] that the subscription finds also include the count of quotes that it has
class QuotesCountSearchExtension extends IncludeSearchExtension {
  QuotesCountSearchExtension({this.forKind = ModifiablePostEntity.kind});

  @override
  final int forKind;

  @override
  String get query => 'kind6400+kind30175+group+q';
}

/// For every kind [forKind] that the subscription finds also include the count of reactions that it has
class ReactionsCountSearchExtension extends IncludeSearchExtension {
  ReactionsCountSearchExtension({this.forKind = ModifiablePostEntity.kind});

  @override
  final int forKind;

  @override
  final String query = 'kind6400+kind7+group+content';
}

/// For every kind [forKind] that the subscription finds also include 1 root/not-root replay
/// that the logged in user made to it — if any
class ReplySampleSearchExtension extends IncludeSearchExtension {
  ReplySampleSearchExtension({
    required this.currentPubkey,
    this.forKind = ModifiablePostEntity.kind,
    this.root = true,
  });

  final bool root;

  final String currentPubkey;

  @override
  final int forKind;

  @override
  String get query => '$currentPubkey@kind30175+e+${root ? 'root' : 'reply'}';
}

/// For every kind [forKind] that the subscription finds also include 1 reaction event
/// that the logged in user made for it — if any
class ReactionsSearchExtension extends IncludeSearchExtension {
  ReactionsSearchExtension({required this.currentPubkey, this.forKind = ModifiablePostEntity.kind});

  final String currentPubkey;

  @override
  final int forKind;

  @override
  String get query => '$currentPubkey@kind7';
}

/// For every kind [forKind] that the subscription finds also include 1 quote post
/// that the logged in user made for it — if any
class QuoteSampleSearchExtension extends IncludeSearchExtension {
  QuoteSampleSearchExtension({
    required this.currentPubkey,
    this.forKind = ModifiablePostEntity.kind,
  });

  final String currentPubkey;

  @override
  final int forKind;

  @override
  String get query => '$currentPubkey@kind30175+q';
}

/// For every kind [forKind] that the subscription finds also include 1 repost
/// that the logged in user made for it — if any
class GenericRepostSampleSearchExtension extends IncludeSearchExtension {
  GenericRepostSampleSearchExtension({
    required this.currentPubkey,
    this.forKind = ModifiablePostEntity.kind,
  });

  final String currentPubkey;

  @override
  final int forKind;

  @override
  String get query => '$currentPubkey@kind16';
}

class GenericIncludeSearchExtension extends IncludeSearchExtension {
  GenericIncludeSearchExtension({required this.forKind, required this.includeKind});

  @override
  final int forKind;

  final int includeKind;

  @override
  String get query => 'kind$includeKind';
}

/// true → only events that have the expiration tag set and have not expired yet are included
/// false → only events that DO NOT have the expiration tag set are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have the expiration tag or not
///
/// When querying for kind 6 events this extension instead applies to the kind 1 event it points to
class ExpirationSearchExtension extends SearchExtension {
  ExpirationSearchExtension({required this.expiration});

  final bool expiration;

  @override
  String get query => 'expiration:$expiration';
}

/// true → only events that have at least 1 imeta tag with any video based mime type are included
/// false → only events that DO NOT have any imeta tag with any video based mime type are included,
/// but those events can still have imeta tags of images or any other non-video file type.
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any imeta tag with any video based mime type or not
///
/// When querying for kind 6/16 events this extension instead applies to the kind 1/30023 event it points to
class VideosSearchExtension extends SearchExtension {
  VideosSearchExtension({required this.contain});

  final bool contain;

  @override
  String get query => 'videos:$contain';
}

/// true → only events that have at least 1 imeta tag with any image based mime type are included
/// false → only events that DO NOT have any imeta tag with any image based mime type are included,
/// but those events can still have imeta tags of videos or any other non-image file type
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any imeta tag with any image based mime type or not
///
/// When querying for kind 6/16 events this extension instead applies to the kind 1/30023 event it points to
class ImagesSearchExtension extends SearchExtension {
  ImagesSearchExtension({required this.contain});

  final bool contain;

  @override
  String get query => 'images:$contain';
}

/// true → only events that have at least 1 [tagName] tag with any value are included
/// false → only events that DO NOT have any [tagName] tag with any value are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any [tagName] tag with any value or not
///
/// When querying for kind 6/16 events this extension instead applies to the kind 1/30023 event it points to
class TagSearchExtension extends SearchExtension {
  TagSearchExtension({required this.tagName, required this.contain});

  final bool contain;

  final String tagName;

  @override
  String get query => '${tagName}tag:$contain';
}

/// true → only events that have the q tag set are included
/// false → only events that DO NOT have the q tag set are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have the q tag set or not
///
/// When querying for kind 6 events this extension instead applies to the kind 1 event it points to
class QuotesSearchExtension extends SearchExtension {
  QuotesSearchExtension({required this.contain});

  final bool contain;

  @override
  String get query => 'quotes:$contain';
}

/// true → only events that have at least 1 e tag are included
/// false → only events that DO NOT have any e tags are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any e tags or not
///
/// This extension is ignored when querying kind 6 events
class ReferencesSearchExtension extends SearchExtension {
  ReferencesSearchExtension({required this.contain});

  final bool contain;

  @override
  String get query => 'references:$contain';
}

/// Applies to the marker of any tag, I.E. like the one on the e tag
/// emarker:root → only events that have at least 1 e tag with the root marker are included
/// emarker:reply → only events that have at least 1 e tag with the reply marker are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any tag with that specific marker or not
///
/// When querying for kind 6 events this extension instead applies to the kind 1 event it points to
class TagMarkerSearchExtension extends SearchExtension {
  TagMarkerSearchExtension({required this.tagName, required this.marker, this.negative = false});

  final String tagName;

  final String marker;

  final bool negative;

  @override
  String get query => '${negative ? '!' : ''}${tagName}marker:$marker';
}

/// For every kind [forKind] that the subscription finds also include mentions (kind 10002)
class MentionsSearchExtension extends IncludeSearchExtension {
  MentionsSearchExtension({this.forKind = UserMetadataEntity.kind});

  @override
  final int forKind;

  @override
  String get query => 'kind10002';
}

/// Wraps a search query in quotes to perform an exact match search
class QuerySearchExtension extends SearchExtension {
  QuerySearchExtension({required this.searchQuery});

  final String searchQuery;

  @override
  String get query => '"$searchQuery"';
}
