// SPDX-License-Identifier: ice License 1.0

abstract class SearchExtension {
  String get query;

  @override
  String toString() => query;
}

class DiscoveryCreatorsSearchExtension extends SearchExtension {
  @override
  final String query = 'discover content creators to follow';
}

/// For every kind 1 that the subscription finds also include the count of replies that it has
class RepliesCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind1+group+reply';
}

/// For every kind 1 that the subscription finds also include the count of root replies that it has
class RootRepliesCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind1+group+root';
}

/// For every kind 1 that the subscription finds also include the count of reposts that it has
class RepostsCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind6+group+e';
}

/// For every kind 1 that the subscription finds also include the count of quotes that it has
class QuotesCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind1+group+q';
}

/// For every kind 1 that the subscription finds also include the count of reactions that it has
class ReactionsCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind7+group+content';
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
  VideosSearchExtension({required this.videos});

  final bool videos;

  @override
  String get query => 'videos:$videos';
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
  ImagesSearchExtension({required this.images});

  final bool images;

  @override
  String get query => 'images:$images';
}

/// true → only events that have at least 1 [tagName] tag with any value are included
/// false → only events that DO NOT have any [tagName] tag with any value are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any [tagName] tag with any value or not
///
/// When querying for kind 6/16 events this extension instead applies to the kind 1/30023 event it points to
class TagSearchExtension extends SearchExtension {
  TagSearchExtension({required this.tagName, required this.has});

  final bool has;

  final String tagName;

  @override
  String get query => '${tagName}tag:$has';
}

/// true → only events that have the q tag set are included
/// false → only events that DO NOT have the q tag set are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have the q tag set or not
///
/// When querying for kind 6 events this extension instead applies to the kind 1 event it points to
class QuotesSearchExtension extends SearchExtension {
  QuotesSearchExtension({required this.quotes});

  final bool quotes;

  @override
  String get query => 'quotes:$quotes';
}

/// true → only events that have at least 1 e tag are included
/// false → only events that DO NOT have any e tags are included
///
/// By default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any e tags or not
///
/// This extension is ignored when querying kind 6 events
class ReferencesSearchExtension extends SearchExtension {
  ReferencesSearchExtension({required this.references});

  final bool references;

  @override
  String get query => 'references:$references';
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
  TagMarkerSearchExtension({required this.tagName, required this.marker});

  final String tagName;

  final String marker;

  @override
  String get query => '${tagName}marker:$marker';
}
