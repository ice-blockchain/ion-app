// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_compression_flutter/image_compression_flutter.dart' as compressor_package;
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_audio_bitrate_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_audio_codec_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_bitrate_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_preset_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_scale_arg.dart';
import 'package:ion/app/services/media_service/ffmpeg_args/ffmpeg_video_codec_arg.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_compress_service.g.dart';

class MediaCompressionService {
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
    bool overwrite = true,
  }) async {
    try {
      final args = [
        const CustomArgument(['-threads', '0']),
        if (overwrite) const CustomArgument(['-y']),
        CustomArgument(['-codec:v', videoCodec.codec]),
        CustomArgument(['-preset', preset.value]),
        CustomArgument(['-b:v', videoBitrate.bitrate]),
        CustomArgument(['-maxrate', maxRate.bitrate]),
        CustomArgument(['-bufsize', bufSize.bitrate]),
        CustomArgument(['-vf', 'scale=${scale.resolution},fps=$fps']),
        CustomArgument(['-codec:a', audioCodec.codec]),
        CustomArgument(['-b:a', audioBitrate.bitrate]),
      ];

      if (kIsWeb) {
        return _compressVideoForWeb(inputFile, args);
      }

      if (Platform.isWindows) {
        await _initWindowsPackage();
      }

      return await _defaultVideoCompress(inputFile, args);
    } catch (error, stackTrace) {
      Logger.log('Error during video compression!', error: error, stackTrace: stackTrace);
      throw Exception('Failed to compress video.');
    }
  }

  Future<XFile> _defaultVideoCompress(XFile inputFile, List<CustomArgument> args) async {
    final output = await _generateOutputPath();
    final savedFilePath = await FileSaver.instance
        .saveFile(name: path.basename(output), bytes: await inputFile.readAsBytes());
    await FFMpegHelper.instance.runSync(
      FFMpegCommand(
        outputFilepath: output,
        inputs: [
          FFMpegInput.asset(savedFilePath),
        ],
        args: args,
      ),
    );

    return XFile(output);
  }

  Future<XFile> getThumbnail(
    XFile inputFile, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    try {
      final outputPath = await _generateOutputPath(isThumbnail: true);
      final file = await FFMpegHelper.instance.getThumbnailFileSync(
        videoPath: inputFile.path,
        fromDuration: duration,
        outputPath: outputPath,
      );

      final compressedImage = await compressImage(
        XFile(file!.path),
        quality: 100,
        size: const Size(200, 200),
      );

      return compressedImage;
    } catch (error, stackTrace) {
      Logger.log('Error during thumbnail extraction!', error: error, stackTrace: stackTrace);
      throw Exception('Failed to extract thumbnail.');
    }
  }

  Future<void> _initWindowsPackage() async {
    final success = await FFMpegHelper.instance.setupFFMpegOnWindows();
    if (!success) {
      Logger.log('Failed to setup ffmpeg on Windows');
      throw Exception('Failed to setup ffmpeg on Windows');
    }
  }

  Future<XFile> _compressVideoForWeb(XFile inputFile, List<CustomArgument> args) async {
    const input = 'input.mp4';
    const output = 'output.mp4';
    final ffmpeg = createFFmpeg(CreateFFmpegParam());

    if (!ffmpeg.isLoaded()) {
      await ffmpeg.load();
    }

    ffmpeg.writeFile(input, await inputFile.readAsBytes());

    await ffmpeg.runCommand(
      "${FFMpegInput.asset(input).toCli()} ${args.map((arg) => FFMpegInput(arg.toArgs()).toCli()).join(' ')} $output",
    );

    final compressedVideoBytes = ffmpeg.readFile(output);
    return XFile.fromData(compressedVideoBytes, name: output);
  }

  Future<XFile> compressImage(
    XFile file, {
    required int quality,
    required Size size,
    bool keepAspectRatio = true,
  }) async {
    try {
      final resizedBytes = await compute<ResizeImageParams, Uint8List>(
        (params) async {
          return resizeImage(params.file, params.size, keepAspectRatio: params.keepAspectRatio);
        },
        ResizeImageParams(file: file, size: size, keepAspectRatio: keepAspectRatio),
      );

      if (resizedBytes.isEmpty) {
        throw Exception('Failed to resize image.');
      }

      final config = compressor_package.ImageFileConfiguration(
        input: compressor_package.ImageFile(
          filePath: '', // File path left empty since we're using rawBytes
          rawBytes: resizedBytes,
        ),
        config: compressor_package.Configuration(
          quality: quality,
        ),
      );

      final output = await compressor_package.compressor.compress(config);

      return XFile.fromData(
        output.rawBytes,
        name: file.name,
        mimeType: file.mimeType,
      );
    } catch (error, stackTrace) {
      Logger.log('Error during image compression!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Uint8List> resizeImage(XFile file, Size size, {bool keepAspectRatio = true}) async {
    try {
      final originalBytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(originalBytes);

      if (decodedImage == null) {
        throw Exception('Failed to decode image.');
      }

      final resizedImage = img.copyResize(
        decodedImage,
        width: size.width.toInt(),
        height: size.height.toInt(),
        maintainAspect: keepAspectRatio,
      );

      return Uint8List.fromList(img.encodePng(resizedImage));
    } catch (error, stackTrace) {
      Logger.log('Error during image resizing!', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<String> _generateOutputPath({bool isThumbnail = false}) async {
    // Get a platform-independent temporary directory
    final tempDir = await getApplicationCacheDirectory();

    // Generate a new output filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = isThumbnail ? 'jpg' : 'mp4';
    final outputFileName = 'compressed_$timestamp.$extension';

    // Join temp directory with the generated filename
    final outputPath = path.join(tempDir.path, outputFileName);

    return outputPath;
  }
}

@riverpod
MediaCompressionService mediaCompressService(MediaCompressServiceRef ref) =>
    MediaCompressionService();

class ResizeImageParams {
  ResizeImageParams({
    required this.file,
    required this.size,
    required this.keepAspectRatio,
  });
  final XFile file;
  final Size size;
  final bool keepAspectRatio;
}
