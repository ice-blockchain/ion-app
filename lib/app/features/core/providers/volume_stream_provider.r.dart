// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volume_stream_provider.r.g.dart';

@riverpod
Stream<double> volumeStream(Ref ref) {
  late StreamController<double> controller;

  controller = StreamController<double>.broadcast(
    onListen: () {
      FlutterVolumeController.addListener((volume) {
        controller.add(volume);
      });
    },
    onCancel: FlutterVolumeController.removeListener,
  );

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
}
