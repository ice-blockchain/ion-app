// SPDX-License-Identifier: ice License 1.0

part of '../audio_message.dart';

class _PlayPauseButton extends ConsumerWidget {
  const _PlayPauseButton({
    required this.audioPlaybackController,
    required this.audioPlaybackState,
    required this.eventMessageId,
  });

  final PlayerController audioPlaybackController;
  final ValueNotifier<PlayerState?> audioPlaybackState;
  final String eventMessageId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (audioPlaybackState.value?.isPlaying ?? false) {
          ref.read(activeAudioMessageProvider.notifier).activeAudioMessage = null;
        } else {
          ref.read(activeAudioMessageProvider.notifier).activeAudioMessage = eventMessageId;
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
                ? IconAssetColored(Assets.svgIconVideoPause, color: context.theme.appColors.primaryAccent, size: 20)
                : IconAssetColored(Assets.svgIconVideoPlay, color: context.theme.appColors.primaryAccent, size: 20);
          },
        ),
      ),
    );
  }
}
