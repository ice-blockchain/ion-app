// SPDX-License-Identifier: ice License 1.0

enum FfmpegPresetArg {
  ultrafast(name: 'Ultrafast', value: 'ultrafast'),
  superfast(name: 'Superfast', value: 'superfast'),
  veryfast(name: 'Veryfast', value: 'veryfast'),
  faster(name: 'Faster', value: 'faster'),
  fast(name: 'Fast', value: 'fast'),
  medium(name: 'Medium', value: 'medium'),
  slow(name: 'Slow', value: 'slow'),
  slower(name: 'Slower', value: 'slower'),
  veryslow(name: 'Veryslow', value: 'veryslow');

  const FfmpegPresetArg({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;
}
