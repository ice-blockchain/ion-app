import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_provider.g.dart';

@riverpod
class BookmarkNotifier extends _$BookmarkNotifier {
  @override
  Set<String> build() {
    return <String>{};
  }

  void toggleBookmark(String id) {
    if (state.contains(id)) {
      state = <String>{...state}..remove(id);
    } else {
      state = <String>{...state}..add(id);
    }
  }
}
