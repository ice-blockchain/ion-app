// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar_recording.dart';

class CancelRecordButton extends ConsumerWidget {
  const CancelRecordButton({
    required this.recorderController,
    super.key,
  });

  final ObjectRef<RecorderController> recorderController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.s),
      child: GestureDetector(
        onTap: () {
          recorderController.value.stop();
          ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
        },
        child: Text(
          'Cancel',
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
