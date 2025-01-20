import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_update_wallet_view_item.c.freezed.dart';
part 'create_update_wallet_view_item.c.g.dart';

@freezed
class CreateUpdateWalletViewItem with _$CreateUpdateWalletViewItem {
  const factory CreateUpdateWalletViewItem({
    required String coinId,
    String? walletId,
  }) = _CreateUpdateWalletViewItem;

  factory CreateUpdateWalletViewItem.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateWalletViewItemFromJson(json);
}
