// SPDX-License-Identifier: ice License 1.0

enum FfmpegScaleArg {
  hd(name: 'HD', resolution: '720'),
  fullHd(name: 'Full HD', resolution: '1080'),
  fourK(name: '4K', resolution: '2160');

  const FfmpegScaleArg({
    required this.name,
    required this.resolution,
  });

  final String name;
  final String resolution;
}
