// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/wipe_styles.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarLinkButton extends StatelessWidget {
  const ToolbarLinkButton({
    required this.textEditorController,
    super.key,
  });
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
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
          if (resultLink.isNotEmpty) {
            wipeAllStyles(textEditorController);
            textEditorController.formatSelection(LinkAttribute(resultLink));
          } else {
            textEditorController.formatSelection(const LinkAttribute(null));
          }
        }
      },
    );
  }

  Future<String?> _showCupertinoLinkDialog({
    required BuildContext context,
    String? initialValue,
  }) {
    final linkController =
        TextEditingController(text: initialValue ?? context.i18n.toolbar_link_placeholder);

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
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(context.i18n.button_cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(context.i18n.button_link),
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
