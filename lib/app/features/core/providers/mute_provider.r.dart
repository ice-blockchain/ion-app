// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ion/app/features/core/providers/volume_stream_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mute_provider.r.g.dart';

@Riverpod(keepAlive: true)
class GlobalMuteNotifier extends _$GlobalMuteNotifier {
  static const _channel = MethodChannel('audio_focus_channel');
  double _previousVolume = 0;

  @override
  bool build() {
    _setupMethodChannelHandler();
    _initializeAudioFocus();
    _setupVolumeListener();
    return true;
  }

  void _setupMethodChannelHandler() {
    _channel.setMethodCallHandler((call) async {
      return null;
    });
  }

  Future<void> _initializeAudioFocus() async {
    await _channel.invokeMethod<bool>('initAudioFocus');
  }

  void _setupVolumeListener() {
    ref.listen(volumeStreamProvider, (previous, next) {
      next.whenData((volume) {
        final currentMuteState = state;
        final prevVol = _previousVolume;

        // If video is muted and volume increased - unmute
        if (currentMuteState && volume > prevVol && volume > 0.0) {
          toggle();
        }

        // If device is in silent mode (volume is 0) - mute video
        if (volume == 0.0 && !currentMuteState) {
          toggle();
        }

        _previousVolume = volume;
      });
    });
  }

  Future<void> toggle() async {
    final willBeMuted = !state;

    var success = false;
    var retries = 0;

    while (!success && retries < 3) {
      if (willBeMuted) {
        final result = await _channel.invokeMethod<bool>('abandonAudioFocus');
        success = result ?? false;
      } else {
        final result = await _channel.invokeMethod<bool>('requestAudioFocus');
        success = result ?? false;
      }

      if (!success) {
        retries++;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }

    if (success) {
      state = willBeMuted;
    }
  }
}
