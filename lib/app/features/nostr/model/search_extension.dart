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

/// true → only events that have at least 1 e tag included
/// false → only events that DO NOT have any e tags included
/// by default (if this extension is not set) ALL events are returned,
/// regardless, whether they have any e tags or not
/// this extension is ignored when querying kind 6 events
class ReferencesSearchExtension extends SearchExtension {
  ReferencesSearchExtension({required this.references});

  final bool references;

  @override
  String get query => 'references:$references';
}
