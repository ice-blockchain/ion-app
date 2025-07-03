// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/utils/quill_style_manager.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarLinkButton extends HookWidget {
  const ToolbarLinkButton({
    required this.textEditorController,
    super.key,
  });
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    final styleManager =
        useMemoized(() => QuillStyleManager(textEditorController), [textEditorController]);

    return ActionsToolbarButton(
      icon: Assets.svg.iconArticleLink,
      onPressed: () async {
        final localContext = context;

        String? existingLink;
        final linkAttribute =
            textEditorController.getSelectionStyle().attributes[Attribute.link.key];
        if (linkAttribute != null) {
          existingLink = linkAttribute.value as String?;
        }

        final resultLink = await _showCupertinoLinkDialog(
          context: localContext,
          initialValue: existingLink,
        );

        if (!localContext.mounted) return;

        if (resultLink != null) {
          styleManager.toggleLinkStyle(resultLink);
        }
      },
    );
  }

  Future<String?> _showCupertinoLinkDialog({
    required BuildContext context,
    String? initialValue,
  }) {
    final linkController = TextEditingController(text: initialValue ?? '');

    return showCupertinoDialog<String>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(context.i18n.toolbar_link_title),
          content: Column(
            children: [
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: linkController,
                placeholder: context.i18n.toolbar_link_placeholder,
                placeholderStyle: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                context.i18n.button_cancel,
                style: TextStyle(color: context.theme.appColors.primaryAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                context.i18n.button_link,
                style: TextStyle(color: context.theme.appColors.primaryAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(linkController.text.trim());
              },
            ),
          ],
        );
      },
    );
  }
}
