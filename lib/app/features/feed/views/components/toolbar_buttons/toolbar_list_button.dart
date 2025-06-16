// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarListButton extends StatelessWidget {
  const ToolbarListButton({
    required this.textEditorController,
    required this.listType,
    super.key,
  });

  final QuillController textEditorController;
  final Attribute<String?> listType;

  @override
  Widget build(BuildContext context) {
    final icon = _iconForType();

    return icon != null
        ? ActionsToolbarButton(
            icon: _iconForType()!,
            onPressed: () {
              _toggleList(textEditorController, listType);
            },
          )
        : const SizedBox.shrink();
  }

  String? _iconForType() {
    switch (listType) {
      case Attribute.ul:
        return Assets.svgIconArticleListdots;
      case Attribute.ol:
        return Assets.svgIconArticleListnumbers;
    }
    return null;
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
