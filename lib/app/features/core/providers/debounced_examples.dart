// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/debounced_provider_wrapper.dart';

// Example 1: Simple Provider
final counterProvider = StateProvider<int>((ref) => 0);

// Debounced version using extension
final debouncedCounterProvider = counterProvider.debounced();

// Example 2: Family Provider
final messageProvider = StateProvider.family<String, String>((ref, userId) => 'Hello $userId');

// Debounced version for specific user (using manual approach)
final debouncedMessageProvider = StateNotifierProvider<DebouncedNotifier<String>, String?>(
  (ref) => DebouncedNotifier<String>(
    ref: ref,
    originalProvider: messageProvider('user123'),
  ),
);

// Example 3: Future Provider
final dataProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Loaded data';
});

// Debounced version
final debouncedDataProvider = dataProvider.debounced(
  debounceDuration: const Duration(milliseconds: 300),
);

// Example 4: Stream Provider  
final streamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(milliseconds: 100), (i) => i);
});

// Debounced version
final debouncedStreamProvider = streamProvider.debounced(
  debounceDuration: const Duration(milliseconds: 500),
);

// Example 5: Complex State Provider
class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
  });

  final String query;
  final List<String> results;
  final bool isLoading;

  SearchState copyWith({
    String? query,
    List<String>? results,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final searchStateProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(),
);

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  void search(String query) {
    state = state.copyWith(query: query, isLoading: true);
    // Simulate search...
    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(
        results: ['Result 1', 'Result 2'],
        isLoading: false,
      );
    });
  }
}

// Debounced version
final debouncedSearchStateProvider = searchStateProvider.debounced();

/// Example widget showing usage
/*
class ExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simple usage
    final counter = ref.watch(debouncedCounterProvider);
    
    // Family provider usage
    final message = ref.watch(debouncedMessageProvider);
    
    // Future provider usage
    final data = ref.watch(debouncedDataProvider);
    
    // Stream provider usage
    final streamValue = ref.watch(debouncedStreamProvider);
    
    // Complex state usage
    final searchState = ref.watch(debouncedSearchStateProvider);
    
    return Column(
      children: [
        Text('Counter: ${counter ?? 0}'),
        Text('Message: ${message ?? ''}'),
        data?.when(
          data: (value) => Text('Data: $value'),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ) ?? CircularProgressIndicator(),
        streamValue?.when(
          data: (value) => Text('Stream: $value'),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ) ?? CircularProgressIndicator(),
        searchState != null
            ? Text('Search: ${searchState.query} (${searchState.results.length} results)')
            : CircularProgressIndicator(),
      ],
    );
  }
}
*/ 