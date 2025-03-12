import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'wallet_flag_tag.c.freezed.dart';

@freezed
class WalletFlagTag with _$WalletFlagTag {
  const factory WalletFlagTag() = _WalletFlagTag;

  const WalletFlagTag._();

  factory WalletFlagTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return const WalletFlagTag();
  }

  static const String tagName = 'L';
  static const String tagValue = 'wallet.address';

  List<String> toTag() => [tagName, tagValue];
}
