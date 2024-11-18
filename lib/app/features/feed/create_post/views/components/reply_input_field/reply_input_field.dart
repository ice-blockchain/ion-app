// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/hooks/use_node_focused.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/create_post/views/components/post_submit_button/post_submit_button.dart';
import 'package:ion/app/features/feed/create_post/views/components/reply_input_field/reply_author_header.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_image_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_poll_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class ReplyInputField extends HookConsumerWidget {
  const ReplyInputField({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController = useQuillController();

    final inputContainerKey = useRef(UniqueKey());
    final focusNode = useFocusNode();
    final hasFocus = useNodeFocused(focusNode);

    return ScreenSideOffset.small(
      child: Column(
        children: [
          SizedBox(height: 12.0.s),
          if (hasFocus.value)
            Padding(
              padding: EdgeInsets.only(bottom: 12.0.s),
              child: ReplyAuthorHeader(pubkey: eventReference.pubkey),
            ),
          SizedBox(
            // When we focus the TextField, a new child is added to the Column,
            // This causes Flutter to rebuild all subsequent children from scratch,
            // which results in the TextField losing focus and the keyboard hiding.
            // Assigning a key to this child ensures that Flutter preserves it during rebuilds.
            key: inputContainerKey.value,
            height: 36.0.s,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.appColors.onSecondaryBackground,
                borderRadius: BorderRadius.circular(16.0.s),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.s),
                child: Row(
                  children: [
                    Flexible(
                      child: TextEditor(
                        textEditorController,
                        focusNode: focusNode,
                        autoFocus: false,
                        placeholder: context.i18n.post_reply_hint,
                      ),
                    ),
                    if (hasFocus.value)
                      GestureDetector(
                        onTap: () async {
                          final content = await CreatePostRoute(
                            parentEvent: eventReference.toString(),
                            showCollapseButton: true,
                            content: textEditorController.document.toPlainText(),
                          ).push<String>(context);
                          if (content != null) {
                            textEditorController
                              ..setContents(
                                Delta.fromJson([
                                  {'insert': content},
                                ]),
                              )
                              ..moveCursorToEnd();
                          }
                        },
                        child: Assets.svg.iconReplysearchScale.icon(size: 20.0.s),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.0.s),
          if (hasFocus.value)
            ActionsToolbar(
              actions: [
                ToolbarImageButton(textEditorController: textEditorController),
                ToolbarPollButton(textEditorController: textEditorController),
              ],
              trailing: PostSubmitButton(
                textEditorController: textEditorController,
                parentEvent: eventReference,
              ),
            ),
        ],
      ),
    );
  }
}
