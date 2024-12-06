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

class RepliesCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind1+group+reply';
}

class RootRepliesCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind1+group+root';
}

class RepostsCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind6+group+e';
}

class QuotesCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind1+group+q';
}

class ReactionsCountSearchExtension extends SearchExtension {
  @override
  final String query = 'include:dependencies:kind1>kind6400+kind7+group+content';
}
