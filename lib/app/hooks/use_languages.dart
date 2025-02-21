// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/core/model/language.dart';

/// A hook that returns a filtered list of languages based on a search query.
///
/// If the [query] is empty, it returns the full list of languages.
List<Language> useLanguages({String query = ''}) {
  return useMemoized(
    () {
      final normalizedQuery = query.toLowerCase().trim();
      return normalizedQuery.isEmpty
          ? Language.values
          : Language.values.where((language) {
              return language.name.toLowerCase().contains(normalizedQuery) ||
                  (language.localName?.toLowerCase().contains(normalizedQuery) ?? false);
            }).toList();
    },
    [query],
  );
}
