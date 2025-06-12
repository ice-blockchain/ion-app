import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/manage_coins_group.c.dart';

part 'manage_coins_state.c.freezed.dart';

@freezed
class ManageCoinsState with _$ManageCoinsState {
  const factory ManageCoinsState({
    required Map<String, ManageCoinsGroup> groups,
    required bool hasMore,
  }) = _ManageCoinsState;
}
