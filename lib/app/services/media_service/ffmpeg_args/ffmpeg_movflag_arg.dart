// SPDX-License-Identifier: ice License 1.0

enum FfmpegMovFlagArg {
  faststart(name: 'faststart', value: '+faststart');

  const FfmpegMovFlagArg({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;
}
