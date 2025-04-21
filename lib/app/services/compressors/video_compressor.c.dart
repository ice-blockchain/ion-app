// SPDX-License-Identifier: ice License 1.0

import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/compressors/compress_executor.c.dart';
import 'package:ion/app/services/compressors/image_compressor.c.dart';
import 'package:ion/app/services/compressors/output_path_generator.dart';
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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_compressor.c.g.dart';

class VideoCompressionConfig {
  const VideoCompressionConfig({
    required this.videoCodec,
    required this.preset,
    required this.videoBitrate,
    required this.maxRate,
    required this.bufSize,
    required this.scale,
    required this.fps,
    required this.audioCodec,
    required this.audioBitrate,
    required this.pixelFormat,
  });

  static const balanced = VideoCompressionConfig(
    videoCodec: FFmpegVideoCodecArg.libx264,
    preset: FfmpegPresetArg.medium,
    videoBitrate: FfmpegBitrateArg.medium,
    maxRate: FfmpegBitrateArg.medium,
    bufSize: FfmpegBitrateArg.medium,
    scale: FfmpegScaleArg.hd,
    fps: 30,
    audioCodec: FfmpegAudioCodecArg.aac,
    audioBitrate: FfmpegAudioBitrateArg.medium,
    pixelFormat: FfmpegPixelFormatArg.yuv420p,
  );

  final FFmpegVideoCodecArg videoCodec;
  final FfmpegPresetArg preset;
  final FfmpegBitrateArg videoBitrate;
  final FfmpegBitrateArg maxRate;
  final FfmpegBitrateArg bufSize;
  final FfmpegScaleArg scale;
  final int fps;
  final FfmpegAudioCodecArg audioCodec;
  final FfmpegAudioBitrateArg audioBitrate;
  final FfmpegPixelFormatArg pixelFormat;
}

class VideoCompressor {
  VideoCompressor({
    required this.compressExecutor,
    required this.imageCompressor,
  });

  final CompressExecutor compressExecutor;
  final ImageCompressor imageCompressor;

  ///
  /// Compresses a video file to a new file with the same name in the application cache directory.
  /// If success, returns a new [MediaFile] with the compressed video.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> compressVideo(
    MediaFile inputFile, {
    VideoCompressionConfig config = VideoCompressionConfig.balanced,
  }) async {
    try {
      final output = await generateOutputPath(extension: 'mp4');

      final args = FFmpegCommands.compressVideo(
        inputPath: inputFile.path,
        outputPath: output,
        videoCodec: config.videoCodec.codec,
        preset: config.preset.value,
        videoBitrate: config.videoBitrate.bitrate,
        maxRate: config.maxRate.bitrate,
        bufSize: config.bufSize.bitrate,
        audioCodec: config.audioCodec.codec,
        audioBitrate: config.audioBitrate.bitrate,
        pixelFormat: config.pixelFormat.name,
        scaleResolution: int.parse(config.scale.resolution),
        fps: config.fps,
      );

      final session = await compressExecutor.execute(args);
      final returnCode = await session.getReturnCode();
      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getAllLogsAsString();
        final stackTrace = await session.getFailStackTrace();
        Logger.log('Failed to compress video. Logs: $logs, StackTrace: $stackTrace');
        throw CompressVideoException(returnCode);
      }

      final (width: outWidth, height: outHeight) = await getVideoDimensions(output);

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
        final outputPath = await generateOutputPath();
        final session = await compressExecutor.execute(
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
        final dims = await getVideoDimensions(videoFile.path);
        width = dims.width;
        height = dims.height;
      }

      // We only pass one dimension to keep aspect ratio
      // If the video is wider, specify the max width;
      // otherwise specify the max height
      final compressedImage = await imageCompressor.compressImage(
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
  /// Get width and height for a video file by probing it with FFprobeKit.
  ///
  Future<({int width, int height})> getVideoDimensions(String videoPath) async {
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
}

@Riverpod(keepAlive: true)
VideoCompressor videoCompressor(Ref ref) => VideoCompressor(
      compressExecutor: ref.read(compressExecutorProvider),
      imageCompressor: ref.read(imageCompressorProvider),
    );
