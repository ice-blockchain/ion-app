// SPDX-License-Identifier: ice License 1.0

enum FfmpegBitrateArg {
  low(name: 'Low', bitrate: '512k'),
  medium(name: 'Medium', bitrate: '1024k'),
  high(name: 'High', bitrate: '2048k');

  const FfmpegBitrateArg({
    required this.name,
    required this.bitrate,
  });

  final String name;
  final String bitrate;
}
