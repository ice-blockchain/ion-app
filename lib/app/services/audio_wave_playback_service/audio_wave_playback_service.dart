// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_saver/file_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_wave_playback_service.g.dart';

class AudioWavePlaybackService {
  const AudioWavePlaybackService(this._mediaCompressionService);
  final MediaCompressionService _mediaCompressionService;

  Future<void> initializePlayer(
    String id,
    String audioUrl,
    PlayerController audioPlaybackController,
    PlayerWaveStyle playerWaveStyle,
  ) async {
    try {
      final cachePath = await _getCachedFilePath(id);

      if (File(cachePath).existsSync()) {
        await preparePlayer(cachePath, audioPlaybackController, playerWaveStyle);
      } else {
        final savedFilePath = await _downloadAudio(id, audioUrl);
        await preparePlayer(savedFilePath, audioPlaybackController, playerWaveStyle);
      }
    } catch (e, s) {
      Logger.log('Error initializing player', error: e, stackTrace: s);
    }
  }

  Future<void> preparePlayer(
    String path,
    PlayerController audioPlaybackController,
    PlayerWaveStyle playerWaveStyle,
  ) async {
    try {
      await audioPlaybackController.preparePlayer(
        path: path,
        noOfSamples: playerWaveStyle.getSamplesForWidth(158.0.s),
      );
    } catch (e, s) {
      Logger.log('Error preparing player', error: e, stackTrace: s);
    }
  }

  Future<String> _getCachedFilePath(String id) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return '${documentsDir.path}/audio_messages/$id';
  }

  Future<String> _downloadAudio(String id, String audioUrl) async {
    final savedFilePath = await FileSaver.instance.saveFile(
      name: id,
      link: LinkDetails(link: audioUrl),
    );
    final compressedFilePath = await _mediaCompressionService.compressAudioToWav(savedFilePath);
    return compressedFilePath;
  }
}

@riverpod
AudioWavePlaybackService audioWavePlaybackService(Ref ref) =>
    AudioWavePlaybackService(ref.watch(mediaCompressServiceProvider));
