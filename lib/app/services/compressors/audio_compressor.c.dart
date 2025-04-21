// SPDX-License-Identifier: ice License 1.0

import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/compressors/compress_executor.c.dart';
import 'package:ion/app/services/compressors/output_path_generator.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/ffmpeg_commands_config.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_compressor.c.g.dart';

class AudioCompressorConfig {
  const AudioCompressorConfig({
    required this.bitrate,
    required this.sampleRate,
  });

  final int bitrate;
  final int sampleRate;

  static const AudioCompressorConfig mediumQuality = AudioCompressorConfig(
    bitrate: 96,
    sampleRate: 24000,
  );
}

class AudioCompressor {
  const AudioCompressor({
    required this.compressExecutor,
  });

  final CompressExecutor compressExecutor;

  ///
  /// Compresses an audio file to opus format using the specified configuration.
  /// If success, returns the path to the compressed audio file.
  /// If fails, throws an exception.
  ///
  Future<MediaFile> compressAudio(
    String inputPath, {
    AudioCompressorConfig config = AudioCompressorConfig.mediumQuality,
  }) async {
    final outputPath = await generateOutputPath(extension: 'opus');
    try {
      final session = await compressExecutor.execute(
        FFmpegCommands.audioToOpus(
          inputPath: inputPath,
          outputPath: outputPath,
          bitrate: config.bitrate,
          sampleRate: config.sampleRate,
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
  /// Compress an audio to wav format using the specified configuration.
  /// If success, returns the path to the compressed audio file.
  /// If fails, throws an exception.
  ///
  Future<String> compressAudioToWav(String inputPath) async {
    final outputPath = await generateOutputPath(extension: 'wav');
    try {
      final session = await compressExecutor.execute(
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
}

@Riverpod(keepAlive: true)
AudioCompressor audioCompressor(Ref ref) => AudioCompressor(
      compressExecutor: ref.read(compressExecutorProvider),
    );
