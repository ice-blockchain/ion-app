enum FfmpegMovFlagArg {
  faststart(name: 'faststart', value: '+faststart');

  const FfmpegMovFlagArg({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;
}
