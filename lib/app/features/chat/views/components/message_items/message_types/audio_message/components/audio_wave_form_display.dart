// SPDX-License-Identifier: ice License 1.0

part of '../audio_message.dart';

class _AudioWaveformDisplay extends HookWidget {
  const _AudioWaveformDisplay({
    required this.audioPlaybackController,
    required this.audioPlaybackState,
    required this.playerWaveStyle,
    required this.isMe,
  });

  final PlayerController audioPlaybackController;
  final ValueNotifier<PlayerState?> audioPlaybackState;
  final PlayerWaveStyle playerWaveStyle;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final maxDuration = useMemoized(
      () => formatDuration(Duration(milliseconds: audioPlaybackController.maxDuration)),
      [audioPlaybackController.maxDuration],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AudioFileWaveforms(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              size: Size(158.0.s, 16.0.s),
              continuousWaveform: false,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: playerWaveStyle,
              playerController: audioPlaybackController,
            ),
            SizedBox(height: 4.0.s),
            Text(
              maxDuration,
              style: context.theme.appTextThemes.caption4.copyWith(
                color: isMe
                    ? context.theme.appColors.strokeElements
                    : context.theme.appColors.quaternaryText,
              ),
            ),
          ],
        );
      },
    );
  }
}
