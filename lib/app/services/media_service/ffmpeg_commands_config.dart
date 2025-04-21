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
    required int scaleResolution,
    required int fps,
  }) =>
      [
        '-i',
        inputPath,
        '-codec:v',
        videoCodec,
        '-preset',
        preset,
        '-b:v',
        videoBitrate,
        '-maxrate',
        maxRate,
        '-bufsize',
        bufSize,
        '-codec:a',
        audioCodec,
        '-b:a',
        audioBitrate,
        '-pix_fmt',
        pixelFormat,
        '-vf',
        'scale=-2:$scaleResolution,fps=$fps',
        outputPath,
      ];

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
    int? width,
    int? height,
  }) =>
      [
        '-i',
        inputPath,
        '-c:v',
        'libwebp',
        '-vf',
        'scale=${width ?? '-1'}:${height ?? '-1'}:force_original_aspect_ratio=decrease',
        '-q:v',
        quality.toString(),
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
