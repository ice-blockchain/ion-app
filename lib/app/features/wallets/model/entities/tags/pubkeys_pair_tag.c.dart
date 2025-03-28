import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'pubkeys_pair_tag.c.freezed.dart';

@freezed
class PubkeysPairTag with _$PubkeysPairTag {
  const factory PubkeysPairTag({
    required String masterPubkey,
    required String devicePubkey,
  }) = _PubkeysPairTag;

  const PubkeysPairTag._();

  factory PubkeysPairTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    return PubkeysPairTag(
      masterPubkey: tag[1],
      devicePubkey: tag[3],
    );
  }

  List<String> toTag() {
    return [tagName, masterPubkey, '', devicePubkey];
  }

  static const String tagName = 'p';
}
