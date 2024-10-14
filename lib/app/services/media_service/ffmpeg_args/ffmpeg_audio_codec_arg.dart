// SPDX-License-Identifier: ice License 1.0

enum FfmpegAudioCodecArg {
  libfdkAac(name: 'AAC (libfdk)', codec: 'libfdk_aac'),
  aac(name: 'AAC', codec: 'aac'),
  opus(name: 'Opus', codec: 'opus');

  const FfmpegAudioCodecArg({
    required this.name,
    required this.codec,
  });

  final String name;
  final String codec;
}
