import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

Future<({List<FileMetadata> fileMetadatas, MediaAttachment mediaAttachment})> uploadImage(
  Ref ref,
  MediaFile file, {
  required FileAlt alt,
}) async {
  const maxDimension = 1024;

  final dimensions = await ref.read(compressServiceProvider).getImageDimension(path: file.path);
  final width = dimensions.width;
  final height = dimensions.height;

  final compressedImage = await ref.read(compressServiceProvider).compressImage(
        file,
        width: width > height ? maxDimension : null,
        height: height > width ? maxDimension : null,
        quality: 70,
      );

  final uploadResult = await ref.read(nostrUploadNotifierProvider.notifier).upload(
        compressedImage,
        alt: alt,
      );

  return (
    fileMetadatas: [uploadResult.fileMetadata],
    mediaAttachment: uploadResult.mediaAttachment
  );
}
