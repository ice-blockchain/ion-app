// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/collaple_button.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class CreatePostAppBar extends StatelessWidget {
  const CreatePostAppBar({
    required this.showCollapseButton,
    required this.createOption,
    required this.textEditorController,
    super.key,
  });

  final bool showCollapseButton;
  final CreatePostOption createOption;
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return NavigationAppBar.modal(
      showBackButton: false,
      title: Text(createOption.getTitle(context)),
      actions: [
        if (showCollapseButton)
          CollapseButton(textEditorController: textEditorController)
        else
          const NavigationCloseButton(),
      ],
    );
  }
}
