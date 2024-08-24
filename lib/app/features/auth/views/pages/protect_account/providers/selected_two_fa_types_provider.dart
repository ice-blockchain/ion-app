import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_two_fa_types_provider.g.dart';

@riverpod
class SelectedTwoFaTypesNotifier extends _$SelectedTwoFaTypesNotifier {
  @override
  List<TwoFaType> build() => [];

  void select(TwoFaType type) {
    state = [...state, type];
  }
}
