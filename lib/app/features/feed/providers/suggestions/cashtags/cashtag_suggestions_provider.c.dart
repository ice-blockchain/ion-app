// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/coins/search_coins_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashtag_suggestions_provider.c.g.dart';

@riverpod
Future<List<String>> cashtagSuggestions(Ref ref, String query) async {
  if (query.isEmpty || !query.startsWith(r'$')) {
    return [];
  }

  final searchQuery = query.substring(1).toLowerCase();
  final searchService = ref.read(searchCoinsServiceProvider);

  try {
    final coinsGroups = await searchService.search(searchQuery);
    return coinsGroups.map((group) => group.symbolGroup).take(10).toList();
  } catch (e) {
    return [];
  }
}
