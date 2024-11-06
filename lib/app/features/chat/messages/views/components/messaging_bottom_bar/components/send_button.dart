// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar.dart';

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.onSend,
  });

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 4.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.primaryAccent,
          borderRadius: BorderRadius.circular(12.0.s),
        ),
        child: Assets.svg.iconChatSendmessage.icon(
          color: context.theme.appColors.onPrimaryAccent,
          size: 24.0.s,
        ),
      ),
    );
  }
}
