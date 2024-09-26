import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/constants/languages.dart';

List<Language> useLanguages({String query = ''}) {
  return useMemoized(
      () => query.isEmpty
          ? Language.values
          : Language.values
              .where((language) => language.name.toLowerCase().contains(query.toLowerCase().trim()))
              .toList(),
      [query]);
}
