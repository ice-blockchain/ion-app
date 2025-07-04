// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/hooks/use_node_focused.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/extensions.dart';

class RichTextInput extends HookConsumerWidget {
  const RichTextInput({
    required this.textEditorKey,
    required this.onChanged,
    required this.labelText,
    required this.prefixIconAssetName,
    this.initialValue,
    this.validator,
    super.key,
  });

  final GlobalKey<TextEditorState> textEditorKey;
  final ValueChanged<String> onChanged;
  final String labelText;
  final String prefixIconAssetName;
  final String? initialValue;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController = useQuillController(content: initialValue);
    final scrollController = useScrollController();
    final focusNode = useFocusNode();
    final hasFocus = useNodeFocused(focusNode);

    final fieldKey = useMemoized(GlobalKey<FormFieldState<String>>.new);
    useEffect(
      () {
        void listener() {
          final doc = textEditorController.document;
          final plain = doc.toPlainText();
          final value = (plain.trim().isEmpty) ? '' : plain;

          fieldKey.currentState?.didChange(value);
          final delta = doc.toDelta().toJson();
          final encoded = value.isEmpty ? '' : jsonEncode(delta);
          onChanged(encoded);
        }

        textEditorController.addListener(listener);
        return () => textEditorController.removeListener(listener);
      },
      [textEditorController, onChanged],
    );

    return FormField<String>(
      key: fieldKey,
      initialValue: initialValue ?? '',
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        final textInputMode = hasFocus.value || state.value.isNotEmpty;
        final activeColor = _getActiveColor(state, hasFocus.value, context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsetsDirectional.only(
                bottom: 13.0.s,
                end: 16.0.s,
                top: textInputMode ? 6.0.s : 13.0.s,
                start: textInputMode ? 16.0.s : 0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: activeColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (textInputMode)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: 3.0.s,
                      ),
                      child: Text(
                        state.errorText ?? labelText,
                        style: context.theme.appTextThemes.caption5.copyWith(
                          color: activeColor,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      if (textInputMode == false)
                        TextInputIcons(
                          hasRightDivider: true,
                          icons: [
                            prefixIconAssetName.icon(
                              color: context.theme.appColors.secondaryText,
                            ),
                          ],
                        ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 20.0.s,
                            maxHeight: 5 * 20.0.s,
                          ),
                          child: TextEditor(
                            textEditorController,
                            focusNode: focusNode,
                            autoFocus: false,
                            placeholder: hasFocus.value ? '' : labelText,
                            key: textEditorKey,
                            scrollable: true,
                            scrollController: scrollController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getActiveColor(FormFieldState<String> state, bool hasFocus, BuildContext context) {
    if (state.hasError) {
      return context.theme.appColors.attentionRed;
    }
    if (hasFocus) {
      return context.theme.appColors.primaryAccent;
    }
    return context.theme.appColors.strokeElements;
  }
}
