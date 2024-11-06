// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar_recording.dart';

class DeleteAudioButton extends ConsumerWidget {
  const DeleteAudioButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.0.s, 4.0.s, 4.0.s, 4.0.s),
        child: Assets.svg.iconBlockDelete.icon(
          color: context.theme.appColors.primaryText,
          size: 24.0.s,
        ),
      ),
    );
  }
}
