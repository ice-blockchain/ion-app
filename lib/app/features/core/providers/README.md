# Generic Debounced Provider Wrapper

This package provides a generic debounced wrapper for any Riverpod provider to prevent rapid UI updates.

## Features

- **Generic**: Works with any Riverpod provider type
- **Easy to use**: Simple extension methods and factory functions
- **Configurable**: Customizable debounce duration
- **Performance**: Reduces unnecessary widget rebuilds

## Usage

### 1. Simple Provider

```dart
final counterProvider = StateProvider<int>((ref) => 0);

// Debounced version using extension
final debouncedCounterProvider = counterProvider.debounced();

// Usage in widget
Consumer(
  builder: (context, ref, child) {
    final counter = ref.watch(debouncedCounterProvider);
    return Text('Counter: ${counter ?? 0}');
  },
)
```

### 2. Family Provider

```dart
final messageProvider = StateProvider.family<String, String>((ref, userId) => 'Hello $userId');

// Debounced version for specific parameter
final debouncedMessageProvider = StateNotifierProvider<DebouncedNotifier<String>, String?>(
  (ref) => DebouncedNotifier<String>(
    ref: ref,
    originalProvider: messageProvider('user123'),
    debounceDuration: const Duration(milliseconds: 200),
  ),
);
```

### 3. Future Provider

```dart
final dataProvider = FutureProvider<String>((ref) async {
  // Some async operation
  return 'data';
});

final debouncedDataProvider = dataProvider.debounced(
  debounceDuration: const Duration(milliseconds: 300),
);
```

### 4. Complex State Provider

```dart
final searchStateProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(),
);

final debouncedSearchStateProvider = searchStateProvider.debounced();
```

### 5. Real-world Example (Followers List)

```dart
// Transform raw data to UI-friendly state
final followersListStateProvider = Provider.family<FollowersListState, ({String pubkey, String? query})>((ref, params) {
  final dataSource = ref.watch(followersDataSourceProvider(params.pubkey, query: params.query));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  
  return FollowersListState(
    entities: entitiesPagedData?.data.items?.whereType<UserMetadataEntity>().toList(),
    hasMore: entitiesPagedData?.hasMore ?? false,
    isLoading: entitiesPagedData?.data is PagedLoading,
  );
});

// Debounced version
final debouncedFollowersListStateProvider = Provider.family<StateNotifierProvider<DebouncedNotifier<FollowersListState>, FollowersListState?>, ({String pubkey, String? query})>((ref, params) {
  return followersListStateProvider(params).debounced();
});

// Usage in widget
class FollowersListWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final debouncedProvider = ref.watch(debouncedFollowersListStateProvider((pubkey: pubkey, query: query)));
    final state = ref.watch(debouncedProvider);
    
    final entities = state?.entities;
    
    if (entities == null) return LoadingWidget();
    if (entities.isEmpty) return EmptyWidget();
    
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(entities[index].name),
      ),
    );
  }
}
```

## API Reference

### Extension Methods

```dart
extension ProviderDebouncedExtension<T> on ProviderListenable<T> {
  StateNotifierProvider<DebouncedNotifier<T>, T?> debounced({
    Duration debounceDuration = const Duration(milliseconds: 150),
    String? name,
  });
}
```

### Factory Functions

```dart
StateNotifierProvider<DebouncedNotifier<T>, T?> createDebouncedProvider<T, P>(
  ProviderListenable<T> originalProvider, {
  Duration debounceDuration = const Duration(milliseconds: 150),
  String? name,
});

StateNotifierProvider<DebouncedNotifier<T>, T?> createDebouncedFamilyProvider<T, P>(
  ProviderFamily<T, P> originalProviderFamily,
  P parameter, {
  Duration debounceDuration = const Duration(milliseconds: 150),
  String? name,
});
```

### Core Classes

```dart
class DebouncedNotifier<T> extends StateNotifier<T?> {
  DebouncedNotifier({
    required Ref ref,
    required ProviderListenable<T> originalProvider,
    Duration debounceDuration = const Duration(milliseconds: 150),
  });
}
```

## Benefits

1. **Reduces UI Jank**: Prevents rapid widget rebuilds during data loading
2. **Better UX**: Smoother animations and transitions
3. **Performance**: Lower CPU usage and battery consumption
4. **Flexibility**: Works with any provider type and state
5. **Simple**: Easy to add to existing providers with minimal changes

## Configuration

- **Default debounce duration**: 150ms
- **Customizable**: Set any duration based on your needs
- **Per-provider**: Each debounced provider can have its own timing

## When to Use

- API data that updates frequently (like followers, search results)
- Real-time data streams
- Form validation states
- Any provider where rapid updates cause UI performance issues 