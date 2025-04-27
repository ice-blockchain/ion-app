// SPDX-License-Identifier: ice License 1.0

enum FfmpegBitrateArg {
  lowest(name: 'Lowest', bitrate: '500k'),
  low(name: 'Low', bitrate: '1000k'),
  medium(name: 'Medium', bitrate: '2000k'),
  high(name: 'High', bitrate: '4000k'),
  highest(name: 'Highest', bitrate: '8000k');

  const FfmpegBitrateArg({
    required this.name,
    required this.bitrate,
  });

  final String name;
  final String bitrate;
}
