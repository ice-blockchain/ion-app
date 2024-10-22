// SPDX-License-Identifier: ice License 1.0

sealed class SearchExtension {
  String get query;

  @override
  String toString() => query;
}

class DiscoveryCreatorsSearchExtension extends SearchExtension {
  @override
  final String query = 'discover content creators to follow';
}
