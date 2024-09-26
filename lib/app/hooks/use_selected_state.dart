import 'package:flutter_hooks/flutter_hooks.dart';

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
