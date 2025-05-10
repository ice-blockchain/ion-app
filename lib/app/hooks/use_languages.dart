// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/core/model/language.dart';

/// A hook that returns a filtered list of languages based on a search query.
///
/// If the [query] is empty, it returns the full list of languages.
/// If [preferredLangs] are provided, they are moved to the top of the list.
List<Language> useLanguages({String query = '', List<Language> preferredLangs = const []}) {
  final languagesList = useMemoized(
    () {
      if (preferredLangs.isEmpty) return Language.values;
      final languagesSet = {...Language.values}..removeAll(preferredLangs);
      return languagesSet.toList()..insertAll(0, preferredLangs);
    },
    [preferredLangs],
  );

  return useMemoized(
    () {
      final normalizedQuery = query.toLowerCase().trim();
      return normalizedQuery.isEmpty
          ? languagesList
          : languagesList.where((language) {
              return language.name.toLowerCase().contains(normalizedQuery) ||
                  (language.localName?.toLowerCase().contains(normalizedQuery) ?? false);
            }).toList();
    },
    [query, languagesList],
  );
}
