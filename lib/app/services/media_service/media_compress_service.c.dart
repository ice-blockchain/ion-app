// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';
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
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_compress_service.c.g.dart';

///
/// A service that handles media file compression.
/// Provides methods to compress video and audio  and image files using FFmpeg,
/// with configurable compression parameters
/// TODO: Support windows and web platforms
///
class MediaCompressionService {
  ///
  /// Compresses a video file to a new file with the same name in the application cache directory.
  /// If success, returns a new [XFile] with the compressed video.
  /// If fails, throws an exception.
  ///
  Future<XFile> compressVideo(
    XFile inputFile, {
    FFmpegVideoCodecArg videoCodec = FFmpegVideoCodecArg.libx264,
    FfmpegPresetArg preset = FfmpegPresetArg.fast,
    FfmpegBitrateArg videoBitrate = FfmpegBitrateArg.medium,
    FfmpegBitrateArg maxRate = FfmpegBitrateArg.medium,
    FfmpegBitrateArg bufSize = FfmpegBitrateArg.medium,
    FfmpegScaleArg scale = FfmpegScaleArg.fullHd,
    int fps = 30,
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
        // TODO: Add scale and fps
        output,
      ];
      return await FFmpegKit.executeWithArguments(args).then((session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          return XFile(output);
        }
        final logs = await session.getAllLogsAsString();
        final stackTrace = await session.getFailStackTrace();
        Logger.log('Failed to compress video. Logs: $logs, StackTrace: $stackTrace');
        throw Exception('Failed to compress video.');
      });
    } catch (error, stackTrace) {
      Logger.log('Error during video compression!', error: error, stackTrace: stackTrace);
      throw Exception('Failed to compress video.');
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

      final outputDimension = await _getImageDimension(path: output);

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
  Future<String> compressAudio(String inputPath) async {
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
        return outputPath;
      }
      final logs = await session.getAllLogsAsString();
      final stackTrace = await session.getFailStackTrace();
      Logger.log('Failed to convert audio to opus. Logs: $logs, StackTrace: $stackTrace');
      throw Exception('Failed to convert audio to opus.');
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
      throw Exception('Failed to convert audio to wav.');
    });
  }

  ///
  ///
  /// Extracts a thumbnail from a video file.
  /// If success, returns a new [MediaFile] with the thumbnail.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> getThumbnail(
    MediaFile inputFile, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    try {
      final outputPath = await _generateOutputPath();
      await FFmpegKit.executeWithArguments([
        '-i',
        inputFile.path,
        '-ss',
        '00:00:01.000',
        '-vframes',
        '1',
        outputPath,
      ]);

      final compressedImage = await compressImage(
        MediaFile(path: outputPath),
        quality: 100,
        width: 200,
        height: 200,
      );

      return compressedImage;
    } catch (error, stackTrace) {
      Logger.log('Error during thumbnail extraction!', error: error, stackTrace: stackTrace);
      throw Exception('Failed to extract thumbnail.');
    }
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
  Future<({int width, int height})> _getImageDimension({required String path}) async {
    final file = File(path);
    final imageBytes = await file.readAsBytes();

    final codec = await instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    return (width: image.width, height: image.height);
  }
}

@riverpod
MediaCompressionService mediaCompressService(Ref ref) => MediaCompressionService();