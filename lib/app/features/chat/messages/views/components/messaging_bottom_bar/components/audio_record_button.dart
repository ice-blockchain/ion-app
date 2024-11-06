// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar.dart';

class _AudioRecordButton extends HookConsumerWidget {
  const _AudioRecordButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(4.0.s),
        child: Assets.svg.iconChatMicrophone.icon(
          color: context.theme.appColors.primaryText,
          size: 24.0.s,
        ),
      ),
    );
  }
}

class AudioRecordingButton extends HookConsumerWidget {
  const AudioRecordingButton({required this.paddingBottom, super.key});

  final double paddingBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayEntry = useRef<OverlayEntry?>(null);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final overlay = Overlay.of(context);
          overlayEntry.value = OverlayEntry(
            builder: (context) {
              return _RecordingOverlay(
                paddingBottom: paddingBottom,
              );
            },
          );
          overlay.insert(overlayEntry.value!);
        });
        return () {
          overlayEntry.value?.remove();
          overlayEntry.value = null;
        };
      },
      [paddingBottom],
    );

    return const SizedBox.shrink();
  }
}
