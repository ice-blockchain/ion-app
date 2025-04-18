// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:ui';

import 'package:es_compression/brotli.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_audio_bitrate_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_audio_codec_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_bitrate_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_pixel_format_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_preset_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_scale_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_video_codec_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_commands_config.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:ion/app/utils/image_path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'compress_service.c.g.dart';

final brotliCodec = BrotliCodec(level: 0);

///
/// A service that handles file compression.
/// - Compresses video, audio and image files using FFmpeg with configurable compression parameters;
/// - Compresses/decompresses any files with Brotli.
///
/// TODO: Support windows and web platforms
///
class CompressionService {
  final _lock = Lock();

  ///
  /// Compresses a video file to a new file with the same name in the application cache directory.
  /// If success, returns a new [MediaFile] with the compressed video.
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
    FfmpegPixelFormatArg pixelFormat = FfmpegPixelFormatArg.yuv420p,
  }) async {
    try {
      final output = await _generateOutputPath(extension: 'mp4');

      final args = FFmpegCommands.compressVideo(
        inputPath: inputFile.path,
        outputPath: output,
        videoCodec: videoCodec.codec,
        preset: preset.value,
        videoBitrate: videoBitrate.bitrate,
        maxRate: maxRate.bitrate,
        bufSize: bufSize.bitrate,
        audioCodec: audioCodec.codec,
        audioBitrate: audioBitrate.bitrate,
        pixelFormat: pixelFormat.name,
        scaleResolution: int.parse(scale.resolution),
        fps: fps,
      );

      final session = await _executeFFmpeg(args);
      final returnCode = await session.getReturnCode();
      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getAllLogsAsString();
        final stackTrace = await session.getFailStackTrace();
        Logger.log('Failed to compress video. Logs: $logs, StackTrace: $stackTrace');
        throw CompressVideoException(returnCode);
      }

      final (width: outWidth, height: outHeight) = await _getVideoDimensions(output);

      // Return the final compressed video file info
      return MediaFile(
        path: output,
        mimeType: 'video/mp4',
        width: outWidth,
        height: outHeight,
        duration: inputFile.duration,
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
    bool shouldCompressGif = false,
  }) async {
    try {
      final output = await _generateOutputPath();

      List<String> command;
      if (file.mimeType == 'image/gif' && file.path.isGif && shouldCompressGif) {
        command = FFmpegCommands.gifToAnimatedWebP(
          inputPath: file.path,
          outputPath: output,
          quality: quality,
        );
      } else {
        command = FFmpegCommands.imageToWebP(
          inputPath: file.path,
          outputPath: output,
          quality: quality,
          width: width,
          height: height,
        );
      }

      final session = await _executeFFmpeg(command);

      final returnCode = await session.getReturnCode();
      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getAllLogsAsString();
        final stackTrace = await session.getFailStackTrace();
        Logger.log('Failed to compress image. Logs: $logs, StackTrace: $stackTrace');
        throw CompressImageException(returnCode);
      }

      // For images, we can easily decode to get actual width/height
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
    try {
      final session = await _executeFFmpeg(
        FFmpegCommands.audioToOpus(
          inputPath: inputPath,
          outputPath: outputPath,
        ),
      );

      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return MediaFile(
          path: outputPath,
          mimeType: 'audio/ogg',
          width: 0,
          height: 0,
        );
      }
      final logs = await session.getAllLogsAsString();
      final stackTrace = await session.getFailStackTrace();
      Logger.log('Failed to convert audio to opus. Logs: $logs, StackTrace: $stackTrace');
      throw CompressAudioException();
    } catch (error, stackTrace) {
      Logger.log('Error during audio compression!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  ///
  /// Compress an audio to wav format.
  /// If success, returns the path to the compressed audio file.
  /// If fails, throws an exception.
  ///
  Future<String> compressAudioToWav(String inputPath) async {
    final outputPath = await _generateOutputPath(extension: 'wav');
    try {
      final session = await _executeFFmpeg(
        FFmpegCommands.audioToWav(
          inputPath: inputPath,
          outputPath: outputPath,
        ),
      );

      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      }
      final logs = await session.getAllLogsAsString();
      final stackTrace = await session.getFailStackTrace();
      Logger.log('Failed to convert audio to wav. Logs: $logs, StackTrace: $stackTrace');
      throw CompressAudioToWavException();
    } catch (error, stackTrace) {
      Logger.log('Error during audio compression!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  ///
  /// Extracts a thumbnail from a video file or processes the provided [thumb].
  /// If success, returns a new [MediaFile] with the thumbnail.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> getThumbnail(
    MediaFile videoFile, {
    String? thumb,
  }) async {
    try {
      const maxDimension = 720;
      var thumbPath = thumb;

      // If no external thumb was provided, extract a single frame from the video
      if (thumbPath == null) {
        final outputPath = await _generateOutputPath();
        final session = await _executeFFmpeg(
          FFmpegCommands.extractThumbnail(
            videoPath: videoFile.path,
            outputPath: outputPath,
          ),
        );

        final returnCode = await session.getReturnCode();
        if (!ReturnCode.isSuccess(returnCode)) {
          throw ExtractThumbnailException(returnCode);
        }
        thumbPath = outputPath;
      }

      // If width/height are null, let's probe the video
      var (width, height) = (videoFile.width, videoFile.height);
      if (width == null || height == null) {
        final dims = await _getVideoDimensions(videoFile.path);
        width = dims.width;
        height = dims.height;
      }

      // We only pass one dimension to keep aspect ratio
      // If the video is wider, specify the max width;
      // otherwise specify the max height
      final compressedImage = await compressImage(
        MediaFile(path: thumbPath),
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
  Future<MediaFile> compressWithBrotli(File inputFile) async {
    try {
      final inputData = await inputFile.readAsBytes();
      final compressedData = brotliCodec.encode(inputData);
      return _saveBytesIntoFile(bytes: compressedData, extension: 'br');
    } catch (error, stackTrace) {
      Logger.log('Error during Brotli compression!', error: error, stackTrace: stackTrace);
      throw CompressWithBrotliException();
    }
  }

  ///
  /// Decompresses a Brotli-compressed file.
  ///
  Future<File> decompressBrotli(List<int> compressedData, {String outputExtension = ''}) async {
    try {
      final decompressedData = brotliCodec.decode(compressedData);
      final outputFile =
          await _saveBytesIntoFile(bytes: decompressedData, extension: outputExtension);

      return File(outputFile.path);
    } catch (error, stackTrace) {
      Logger.log('Error during Brotli decompression!', error: error, stackTrace: stackTrace);
      throw DecompressBrotliException();
    }
  }

  Future<MediaFile> _saveBytesIntoFile({
    required List<int> bytes,
    required String extension,
  }) async {
    final outputFilePath = await _generateOutputPath(extension: extension);
    final outputFile = File(outputFilePath);
    await outputFile.writeAsBytes(bytes);

    return MediaFile(
      path: outputFilePath,
      mimeType: 'application/brotli',
      width: 0,
      height: 0,
    );
  }

  ///
  /// Generates a new output path for a compressed file.
  ///
  Future<String> _generateOutputPath({String extension = 'webp'}) async {
    // Get a platform-independent temporary directory
    final tempDir = await getApplicationCacheDirectory();

    // Generate a new output filename
    final uuid = generateUuid();
    final outputFileName = 'compressed_$uuid.$extension';

    // Join temp directory with the generated filename
    final outputPath = path.join(tempDir.path, outputFileName);
    return outputPath;
  }

  ///
  /// Get width and height for a bitmap image (PNG, JPEG, WebP, etc.)
  ///
  Future<({int width, int height})> getImageDimension({required String path}) async {
    final file = File(path);
    final imageBytes = await file.readAsBytes();
    final codec = await instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    return (width: image.width, height: image.height);
  }

  ///
  /// Get width and height for a video file by probing it with FFprobeKit.
  ///
  Future<({int width, int height})> _getVideoDimensions(String videoPath) async {
    final infoSession = await FFprobeKit.getMediaInformation(videoPath);
    final info = infoSession.getMediaInformation();
    if (info == null) {
      throw UnknownFileResolutionException(
        'No media information found for: $videoPath',
      );
    }
    final streams = info.getStreams();
    if (streams.isEmpty) {
      throw UnknownFileResolutionException(
        'No streams found in media: $videoPath',
      );
    }

    final videoStream = streams.firstWhere(
      (s) => s.getType() == 'video',
      orElse: () => throw UnknownFileResolutionException(
        'No video stream found in file: $videoPath',
      ),
    );

    final width = videoStream.getWidth();
    final height = videoStream.getHeight();
    if (width == null || height == null) {
      throw UnknownFileResolutionException(
        'Could not determine video resolution for: $videoPath',
      );
    }
    return (width: width, height: height);
  }

  Future<FFmpegSession> _executeFFmpeg(List<String> args) async {
    return _lock.synchronized(() async {
      return FFmpegKit.executeWithArguments(args);
    });
  }
}

@Riverpod(keepAlive: true)
CompressionService compressService(Ref ref) => CompressionService();
