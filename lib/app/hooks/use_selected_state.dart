import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that manages a selection state of items of type T.
///
/// Can be used in any UI component where users need to select/deselect
/// multiple items, such as checkboxes, tags, categories, favorite etc.
(List<T>, void Function(T)) useSelectedState<T>([List<T> initialState = const []]) {
  final selected = useState<Set<T>>(initialState.toSet());

  void toggleSelection(T item) {
    final newSelected = {...selected.value};
    if (selected.value.contains(item)) {
      newSelected.remove(item);
    } else {
      newSelected.add(item);
    }
    selected.value = newSelected;
  }

  return (selected.value.toList(), toggleSelection);
}
