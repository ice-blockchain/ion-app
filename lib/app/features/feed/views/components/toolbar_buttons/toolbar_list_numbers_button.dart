// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarListNumbersButton extends StatelessWidget {
  const ToolbarListNumbersButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconArticleListnumbers,
      onPressed: () {
        _toggleList(textEditorController, Attribute.ol);
      },
    );
  }

  void _toggleList(QuillController controller, Attribute<String?> listType) {
    final currentAttribute = controller.getSelectionStyle().attributes[Attribute.list.key];

    if (currentAttribute != null && currentAttribute.value == listType.value) {
      controller.formatSelection(Attribute.clone(Attribute.list, null));
    } else {
      controller.formatSelection(listType);
    }
  }
}
