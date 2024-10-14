// SPDX-License-Identifier: ice License 1.0

enum FfmpegScaleArg {
  hd(name: 'HD', resolution: '-1:720'),
  fullHd(name: 'Full HD', resolution: '-1:1080'),
  fourK(name: '4K', resolution: '-1:2160');

  const FfmpegScaleArg({
    required this.name,
    required this.resolution,
  });

  final String name;
  final String resolution;
}
