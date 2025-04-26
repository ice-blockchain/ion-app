// SPDX-License-Identifier: ice License 1.0

class FFmpegCommands {
  const FFmpegCommands._();

  /// Commands for compressing video
  static List<String> compressVideo({
    required String inputPath,
    required String outputPath,
    required String videoCodec,
    required String preset,
    required String videoBitrate,
    required String maxRate,
    required String bufSize,
    required String audioCodec,
    required String audioBitrate,
    required String pixelFormat,
    required String scaleResolution,
    required int fps,
  }) {
    return [
      '-i',
      inputPath,
      '-codec:v',
      videoCodec,
      '-preset',
      'slow',
      '-maxrate',
      '4000k',
      '-bufsize',
      '8000k',
      '-movflags',
      '+faststart',
      '-codec:a',
      audioCodec,
      '-b:a',
      audioBitrate,
      '-pix_fmt',
      pixelFormat,
      '-vf',
      scaleResolution,
      outputPath,
    ];
  }

  /// Commands for converting/compressing GIF to animated WebP
  static List<String> gifToAnimatedWebP({
    required String inputPath,
    required String outputPath,
    required int quality,
  }) =>
      [
        '-i',
        inputPath,
        '-c:v',
        'libwebp',
        '-lossless',
        '0',
        '-q:v',
        quality.toString(),
        '-preset',
        'default',
        '-loop',
        '0',
        '-an',
        outputPath,
      ];

  /// Commands for compressing image to WebP with custom dimensions
  static List<String> imageToWebP({
    required String inputPath,
    required String outputPath,
    required int quality,
    required String scaleResolution,
  }) =>
      [
        '-i',
        inputPath,
        '-c:v',
        'libwebp',
        '-vf',
        scaleResolution,
        '-q:v',
        quality.toString(),
        '-map_metadata',
        '-1',
        outputPath,
      ];

  /// Commands for compressing audio to opus format
  static List<String> audioToOpus({
    required String inputPath,
    required String outputPath,
    int bitrate = 64,
    int sampleRate = 48000,
  }) =>
      [
        '-i',
        inputPath,
        '-c:a',
        'libopus',
        '-b:a',
        '${bitrate}k',
        '-ar',
        sampleRate.toString(),
        outputPath,
      ];

  /// Commands for converting audio to WAV format
  static List<String> audioToWav({
    required String inputPath,
    required String outputPath,
  }) =>
      [
        '-i',
        inputPath,
        '-c:a',
        'pcm_s16le',
        outputPath,
      ];

  /// Commands for extracting a thumbnail from a video
  static List<String> extractThumbnail({
    required String videoPath,
    required String outputPath,
    String timestamp = '00:00:01.000',
  }) =>
      [
        '-i',
        videoPath,
        '-ss',
        timestamp,
        '-vframes',
        '1',
        outputPath,
      ];
}
