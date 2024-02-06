import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateProvider<bool> isEmailModeProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return true;
});
