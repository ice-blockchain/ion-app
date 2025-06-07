// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

part 'encrypted_media_file.c.freezed.dart';

@freezed
class EncryptedMediaFile with _$EncryptedMediaFile {
  const factory EncryptedMediaFile({
    required MediaFile mediaFile,
    required String secretKey,
    required String nonce,
    required String mac,
  }) = _EncryptedMediaFile;
}
