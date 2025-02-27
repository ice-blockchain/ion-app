// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:es_compression/brotli.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_audio_bitrate_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_audio_codec_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_bitrate_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_preset_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_scale_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_video_codec_arg.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compress_service.c.g.dart';

///
/// A service that handles file compression.
/// - Compresses video, audio and image files using FFmpeg with configurable compression parameters;
/// - Compresses/decompresses any files with Brotli.
///
/// TODO: Support windows and web platforms
///
class CompressionService {
  ///
  /// Compresses a video file to a new file with the same name in the application cache directory.
  /// If success, returns a new [XFile] with the compressed video.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> compressVideo(
    MediaFile inputFile, {
    FFmpegVideoCodecArg videoCodec = FFmpegVideoCodecArg.libx264,
    FfmpegPresetArg preset = FfmpegPresetArg.fast,
    FfmpegBitrateArg videoBitrate = FfmpegBitrateArg.medium,
    FfmpegBitrateArg maxRate = FfmpegBitrateArg.medium,
    FfmpegBitrateArg bufSize = FfmpegBitrateArg.medium,
    FfmpegScaleArg scale = FfmpegScaleArg.hd,
    int fps = 24,
    FfmpegAudioCodecArg audioCodec = FfmpegAudioCodecArg.aac,
    FfmpegAudioBitrateArg audioBitrate = FfmpegAudioBitrateArg.low,
  }) async {
    try {
      final output = await _generateOutputPath(extension: 'mp4');
      final args = [
        '-i',
        inputFile.path,
        '-codec:v',
        videoCodec.codec,
        '-preset',
        preset.value,
        '-b:v',
        videoBitrate.bitrate,
        '-maxrate',
        maxRate.bitrate,
        '-bufsize',
        bufSize.bitrate,
        '-codec:a',
        audioCodec.codec,
        '-b:a',
        audioBitrate.bitrate,
        '-vf',
        'scale=-2:${scale.resolution},fps=$fps',
        output,
      ];

      final session = await FFmpegKit.executeWithArguments(args);
      final returnCode = await session.getReturnCode();
      final logs = await session.getAllLogsAsString();

      if (logs == null) {
        throw CompressVideoException('no-logs');
      }

      final match = RegExp(r'Stream.*Video:.* (\d+)x(\d+)').firstMatch(logs);

      if (match == null) {
        Logger.log('Failed to compress video. Dimension not found. Logs: $logs');
        throw CompressVideoException('no-dim');
      }

      if (!ReturnCode.isSuccess(returnCode)) {
        final stackTrace = await session.getFailStackTrace();
        Logger.log('Failed to compress video. Logs: $logs, StackTrace: $stackTrace');
        throw CompressVideoException(returnCode);
      }

      return MediaFile(
        path: output,
        mimeType: 'video/mp4',
        width: int.parse(match.group(1)!),
        height: int.parse(match.group(2)!),
      );
    } catch (error, stackTrace) {
      Logger.log('Error during video compression!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  ///
  /// Compresses an image file to webp format.
  /// If success, returns a new [MediaFile] with the compressed image.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> compressImage(
    MediaFile file, {
    int? width,
    int? height,
    int quality = 80,
  }) async {
    try {
      final output = await _generateOutputPath();
      final session = await FFmpegKit.executeWithArguments([
        '-i',
        file.path,
        '-c:v',
        'libwebp',
        '-vf',
        'scale=${width ?? '-1'}:${height ?? '-1'}:force_original_aspect_ratio=decrease',
        '-q:v',
        quality.toString(),
        output,
      ]);
      final returnCode = await session.getReturnCode();
      if (!ReturnCode.isSuccess(returnCode)) {
        throw CompressImageException(returnCode);
      }

      final outputDimension = await getImageDimension(path: output);

      return MediaFile(
        path: output,
        mimeType: 'image/webp',
        width: outputDimension.width,
        height: outputDimension.height,
      );
    } catch (error, stackTrace) {
      Logger.log('Error during image compression!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  ///
  /// Compresses an audio file to opus format.
  /// If success, returns the path to the compressed audio file.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> compressAudio(String inputPath) async {
    final outputPath = await _generateOutputPath(extension: 'opus');
    return FFmpegKit.executeWithArguments([
      '-i',
      inputPath,
      '-c:a',
      'libopus',
      outputPath,
    ]).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        final mimetype = lookupMimeType(outputPath);
        return MediaFile(path: outputPath, mimeType: mimetype, width: 0, height: 0);
      }
      final logs = await session.getAllLogsAsString();
      final stackTrace = await session.getFailStackTrace();
      Logger.log('Failed to convert audio to opus. Logs: $logs, StackTrace: $stackTrace');
      throw CompressAudioException();
    });
  }

  ///
  /// Compress an audio to wav format.
  /// If success, returns the path to the compressed audio file.
  /// If fails, throws an exception.
  ///
  Future<String> compressAudioToWav(String inputPath) async {
    final outputPath = await _generateOutputPath(extension: 'wav');

    return FFmpegKit.executeWithArguments([
      '-i',
      inputPath,
      '-c:a',
      'pcm_s16le',
      outputPath,
    ]).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      }
      final logs = await session.getAllLogsAsString();
      final stackTrace = await session.getFailStackTrace();
      Logger.log('Failed to convert audio to wav. Logs: $logs, StackTrace: $stackTrace');
      throw CompressAudioToWavException();
    });
  }

  ///
  /// Extracts a thumbnail from a video file or processes the provided [thumb].
  /// If success, returns a new [MediaFile] with the thumbnail.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> getThumbnail(MediaFile videoFile, {String? thumb}) async {
    try {
      const maxDimension = 720;

      var thumbPath = thumb;

      if (thumbPath == null) {
        final outputPath = await _generateOutputPath();
        final session = await FFmpegKit.executeWithArguments([
          '-i',
          videoFile.path,
          '-ss',
          '00:00:01.000',
          '-vframes',
          '1',
          outputPath,
        ]);

        final returnCode = await session.getReturnCode();
        if (!ReturnCode.isSuccess(returnCode)) {
          throw ExtractThumbnailException(returnCode);
        }

        thumbPath = outputPath;
      }

      final MediaFile(:width, :height) = videoFile;

      if (height == null || width == null) {
        throw UnknownFileResolutionException();
      }

      final compressedImage = await compressImage(
        MediaFile(path: thumbPath),
        // Do not pass the second dimension to keep the aspect ratio
        width: width > height ? maxDimension : null,
        height: height > width ? maxDimension : null,
      );

      return compressedImage;
    } catch (error, stackTrace) {
      Logger.log('Error during thumbnail extraction!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  ///
  /// Compresses a file using the Brotli algorithm.
  ///
  Future<File> compressWithBrotli(File inputFile) async {
    try {
      // The input buffer needs to be larger than 50% of the total file size
      // for it to be compressed correctly. This is due to this issue:
      // https://github.com/instantiations/es_compression/issues/53
      // Once it is fixed, the current solution needs to be reconsidered.
      const bufferPercentage = 0.6;
      final fileSize = inputFile.lengthSync();

      final brotliCompressor = BrotliCodec(
        inputBufferLength: (fileSize * bufferPercentage).ceil(),
      );
      final inputData = await inputFile.readAsBytes();
      final compressedData = brotliCompressor.encode(inputData);

      return _saveBytesIntoFile(bytes: compressedData, extension: 'br');
    } catch (error, stackTrace) {
      Logger.log('Error during Brotli compression!', error: error, stackTrace: stackTrace);
      throw CompressWithBrotliException();
    }
  }

  ///
  /// Decompresses a Brotli-compressed file.
  ///
  Future<File> decompressBrotli(File compressedFile, {String outputExtension = 'txt'}) async {
    try {
      final compressedData = await compressedFile.readAsBytes();
      final decompressedData = brotli.decode(
        Uint8List.fromList(compressedData),
      );
      return _saveBytesIntoFile(bytes: decompressedData, extension: outputExtension);
    } catch (error, stackTrace) {
      Logger.log('Error during Brotli decompression!', error: error, stackTrace: stackTrace);
      throw DecompressBrotliException();
    }
  }

  Future<File> _saveBytesIntoFile({
    required List<int> bytes,
    required String extension,
  }) async {
    final outputFilePath = await _generateOutputPath(extension: extension);
    final outputFile = File(outputFilePath);
    await outputFile.writeAsBytes(bytes);
    return outputFile;
  }

  ///
  /// Generates a new output path for a compressed file.
  ///
  Future<String> _generateOutputPath({String extension = 'webp'}) async {
    // Get a platform-independent temporary directory
    final tempDir = await getApplicationCacheDirectory();

    // Generate a new output filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputFileName = 'compressed_$timestamp.$extension';

    // Join temp directory with the generated filename
    final outputPath = path.join(tempDir.path, outputFileName);

    return outputPath;
  }

  ///
  /// Get width and height for the given image path
  ///
  Future<({int width, int height})> getImageDimension({required String path}) async {
    final file = File(path);
    final imageBytes = await file.readAsBytes();

    final codec = await instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    return (width: image.width, height: image.height);
  }
}

@riverpod
CompressionService compressService(Ref ref) => CompressionService();
