// SPDX-License-Identifier: ice License 1.0

part of '../audio_message.dart';

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.audioPlaybackController,
    required this.audioPlaybackState,
  });

  final PlayerController audioPlaybackController;
  final ValueNotifier<PlayerState?> audioPlaybackState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (audioPlaybackState.value?.isPlaying ?? false) {
          audioPlaybackController.pausePlayer();
        } else {
          audioPlaybackController
            ..setFinishMode(finishMode: FinishMode.pause)
            ..startPlayer();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadius.circular(12.0.s),
          border: Border.all(
            color: context.theme.appColors.onTerararyFill,
            width: 1.0.s,
          ),
        ),
        child: ValueListenableBuilder<PlayerState?>(
          valueListenable: audioPlaybackState,
          builder: (context, state, child) {
            if (state == null) {
              return const IONLoadingIndicator(
                type: IndicatorType.dark,
              );
            }
            return state.isPlaying
                ? Assets.svg.iconVideoPause.icon(
                    size: 20.0.s,
                    color: context.theme.appColors.primaryAccent,
                  )
                : Assets.svg.iconVideoPlay.icon(
                    size: 20.0.s,
                    color: context.theme.appColors.primaryAccent,
                  );
          },
        ),
      ),
    );
  }
}
