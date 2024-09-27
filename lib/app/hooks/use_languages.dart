import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/features/core/model/language.dart';

/// A hook that returns a filtered list of languages based on a search query.
///
/// If the [query] is empty, it returns the full list of languages.
List<Language> useLanguages({String query = ''}) {
  return useMemoized(
    () => query.isEmpty
        ? Language.values
        : Language.values
            .where((language) => language.name.toLowerCase().contains(query.toLowerCase().trim()))
            .toList(),
    [query],
  );
}
