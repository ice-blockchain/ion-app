import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatAttachmentMenuSwitchButton extends HookConsumerWidget {
  const ChatAttachmentMenuSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  return  if (showMenu.value)
    //               GestureDetector(
    //                 onTap: () async {
    //                   onDefaultMode();
    //                 },
    //                 child: Padding(
    //                   padding: EdgeInsets.all(4.0.s),
    //                   child: Assets.svg.iconChatKeyboard.icon(
    //                     color: context.theme.appColors.primaryText,
    //                     size: 24.0.s,
    //                   ),
    //                 ),
    //               )
    //             else
    //               GestureDetector(
    //                 onTap: () async {
    //                   menuMode();
    //                 },
    //                 child: Padding(
    //                   padding: EdgeInsets.all(4.0.s),
    //                   child: Assets.svg.iconChatAttatch.icon(
    //                     color: context.theme.appColors.primaryText,
    //                     size: 24.0.s,
    //                   ),
    //                 ),
    //               ),

    return Container();
  }
}
