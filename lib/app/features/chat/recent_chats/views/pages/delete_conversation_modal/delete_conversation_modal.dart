// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/e2ee_conversation_management_provider.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteConversationModal extends ConsumerWidget {
  const DeleteConversationModal({required this.conversationIds, super.key});

  final List<String> conversationIds;

  static double get buttonsSize => 56.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonMinimalSize = Size(buttonsSize, buttonsSize);

    return SheetContent(
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.0.s, bottom: 10.0.s),
              child: Assets.svg.actionCreatepostDeletepost.icon(size: 80.0.s),
            ),
            Text(
              context.i18n.chat_delete_modal_title,
              style: context.theme.appTextThemes.title.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8.0.s,
                bottom: 30.0.s,
                left: 36.0.s,
                right: 36.0.s,
              ),
              child: Text(
                context.i18n.chat_delete_modal_description,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button.compact(
                    type: ButtonType.outlined,
                    label: Text(
                      context.i18n.button_cancel,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    minimumSize: buttonMinimalSize,
                  ),
                ),
                SizedBox(
                  width: 15.0.s,
                ),
                Expanded(
                  child: Button.compact(
                    label: Text(
                      context.i18n.button_delete,
                    ),
                    onPressed: () async {
                      await ref
                          .read(e2eeConversationManagementProvider.notifier)
                          .deleteConversations(conversationIds);
                      if (context.mounted) {
                        context.pop();
                      }
                    },
                    minimumSize: buttonMinimalSize,
                    backgroundColor: context.theme.appColors.attentionRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0.s),
          ],
        ),
      ),
    );
  }
}
