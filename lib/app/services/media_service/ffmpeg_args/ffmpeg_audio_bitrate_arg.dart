// SPDX-License-Identifier: ice License 1.0

enum FfmpegAudioBitrateArg {
  low(name: 'Low', bitrate: '32k'),
  medium(name: 'Medium', bitrate: '64k'),
  high(name: 'High', bitrate: '128k');

  const FfmpegAudioBitrateArg({
    required this.name,
    required this.bitrate,
  });

  final String name;
  final String bitrate;
}
