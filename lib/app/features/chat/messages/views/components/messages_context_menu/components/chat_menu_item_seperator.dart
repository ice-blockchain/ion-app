// SPDX-License-Identifier: ice License 1.0

part of '../messages_context_menu.dart';

class _ChatMenuItemSeperator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.s,
      width: double.infinity,
      color: context.theme.appColors.onTerararyFill,
    );
  }
}
