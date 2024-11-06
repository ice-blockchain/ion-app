// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar_recording.dart';

class PauseAudioButton extends StatelessWidget {
  const PauseAudioButton({
    required this.playerController,
    super.key,
  });

  final ObjectRef<PlayerController> playerController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playerController.value.startPlayer(
          finishMode: FinishMode.pause,
        );
      },
      child: Assets.svg.iconVideoPlay.icon(
        color: context.theme.appColors.primaryAccent,
        size: 24.0.s,
      ),
    );
  }
}
