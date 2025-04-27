// SPDX-License-Identifier: ice License 1.0

///
/// FFmpeg scale filter argument that maintains aspect ratio while resizing:
/// - For portrait videos (height > width):
///   - Sets width to -1 (auto) and height to min(1080, input_height)
/// - For landscape videos (width >= height):
///   - Sets height to -1 (auto) and width to min(1080, input_width)
///
/// The escaped commas and backslashes are required for FFmpeg filter syntax.
/// Example: A 4K portrait video (3840x2160) would be scaled to 607x1080
///
enum FfmpegScaleArg {
  hd(
    name: 'HD',
    resolution: r'scale=w=if(gt(ih\,iw)\,-1\,min(720\,iw)):h=if(gt(ih\,iw)\,min(720\,ih)\,-1)',
  ),
  fullHd(
    name: 'Full HD',
    resolution: r'scale=w=if(gt(ih\,iw)\,-1\,min(1080\,iw)):h=if(gt(ih\,iw)\,min(1080\,ih)\,-1)',
  ),
  fourK(
    name: '4K',
    resolution: r'scale=w=if(gt(ih\,iw)\,-1\,min(2160\,iw)):h=if(gt(ih\,iw)\,min(2160\,ih)\,-1)',
  );

  const FfmpegScaleArg({
    required this.name,
    required this.resolution,
  });

  final String name;
  final String resolution;
}
