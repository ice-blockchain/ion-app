import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@riverpod
Future<Raw<VideoPlayerController>> videoController(
  VideoControllerRef ref,
) async {
  final controller = VideoPlayerController.asset('assets/videos/intro.mp4');

  await controller.initialize();
  await controller.setLooping(true);
  await controller.play();

  ref.onDispose(controller.dispose);

  return controller;
}
