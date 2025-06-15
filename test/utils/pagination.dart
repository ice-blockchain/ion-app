// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/pagination.dart';

class _MockPagedSource implements PagedSource {
  _MockPagedSource(this.page, {this.hasMore = true});
  @override
  final int page;
  @override
  final bool hasMore;
}

void main() {
  group('getNextPageSources', () {
    test('returns only sources with hasMore == true', () {
      final sources = <String, PagedSource>{
        'a': _MockPagedSource(1),
        'b': _MockPagedSource(2, hasMore: false),
        'c': _MockPagedSource(1),
      };
      final result = getNextPageSources(sources: sources, limit: 10);
      expect(result.keys, containsAll(['a', 'c']));
      expect(result.keys, isNot(contains('b')));
    });

    test('prioritizes sources with the lowest page', () {
      final sources = <String, PagedSource>{
        'a': _MockPagedSource(3),
        'b': _MockPagedSource(1),
        'c': _MockPagedSource(2),
        'd': _MockPagedSource(2),
      };
      final result = getNextPageSources(sources: sources, limit: 3);
      expect(result.keys, containsAll(['b', 'c', 'd']));
      expect(result.length, 3);
    });

    test('returns up to the specified limit', () {
      final sources = <String, PagedSource>{
        'a': _MockPagedSource(1),
        'b': _MockPagedSource(1),
        'c': _MockPagedSource(2),
      };
      final result = getNextPageSources(sources: sources, limit: 1);
      expect(result.length, 1);
    });

    test('returns empty map if no sources have hasMore', () {
      final sources = <String, PagedSource>{
        'a': _MockPagedSource(1, hasMore: false),
        'b': _MockPagedSource(2, hasMore: false),
      };
      final result = getNextPageSources(sources: sources, limit: 2);
      expect(result, isEmpty);
    });

    test('returns empty map if sources is empty', () {
      final result = getNextPageSources(sources: <String, PagedSource>{}, limit: 2);
      expect(result, isEmpty);
    });

    test('selects all if limit allows', () {
      final sources = <String, PagedSource>{
        'a': _MockPagedSource(1),
        'b': _MockPagedSource(2),
        'c': _MockPagedSource(3),
        'd': _MockPagedSource(4),
      };
      final result = getNextPageSources(sources: sources, limit: 5);
      expect(result.keys, containsAll(['a', 'b', 'c', 'd']));
      expect(result.length, 4);
    });
  });
}
