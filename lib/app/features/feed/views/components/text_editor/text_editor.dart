import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_divider_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_poll_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_single_image_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_bold_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_divider_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_heading1_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_image_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_italic_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_quote_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/toolbar_buttons/text_editor_ul_button.dart';

class TextEditor extends HookWidget {
  const TextEditor({super.key});

  @override
  Widget build(BuildContext context) {
    QuillController _controller = useRef(
      QuillController.basic(),
    ).value;

    useEffect(() {
      return () {
        _controller.dispose();
      };
    }, []);

    return Column(
      children: [
        QuillEditor.basic(
          controller: _controller,
          configurations: QuillEditorConfigurations(
            embedBuilders: [
              TextEditorPollBlockBuilder(),
              TextEditorSingleImageBuilder(),
              TextEditorDividerBuilder(),
            ],
            autoFocus: true,
            placeholder: context.i18n.create_post_modal_placeholder,
            customStyles: _getCustomStyles(context),
            floatingCursorDisabled: true,
          ),
        ),
        SizedBox(height: 100),
        Divider(
          color: context.theme.appColors.primaryText,
          height: 1,
        ),
        TextEditorToolbar(controller: _controller),
      ],
    );
  }

  DefaultStyles _getCustomStyles(BuildContext context) {
    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        HorizontalSpacing(0, 0), // Define vertical spacing
        VerticalSpacing(0, 0), // Line spacing before/after the paragraph
        VerticalSpacing(0, 0), // Spacing before/after the paragraph
        null,
      ),
      h1: DefaultTextBlockStyle(
        context.theme.appTextThemes.headline1.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        HorizontalSpacing(0, 0),
        VerticalSpacing(0, 0),
        VerticalSpacing(0, 0),
        null,
      ),
      lists: DefaultListBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        HorizontalSpacing(0, 0),
        VerticalSpacing(0, 0),
        VerticalSpacing(0, 0),
        null,
        null,
      ),
      bold: context.theme.appTextThemes.body2.copyWith(
        fontWeight: FontWeight.bold,
        color: context.theme.appColors.primaryText,
      ),
      italic: context.theme.appTextThemes.body2.copyWith(
        fontStyle: FontStyle.italic,
        color: context.theme.appColors.primaryText,
      ),
      placeHolder: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
        HorizontalSpacing(0, 0),
        VerticalSpacing(0, 0),
        VerticalSpacing(0, 0),
        null,
      ),
      quote: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
          fontStyle: FontStyle.italic,
        ),
        HorizontalSpacing(0, 0),
        VerticalSpacing(0, 0),
        VerticalSpacing(0, 0),
        BoxDecoration(
          //only left border
          border: Border(
            left: BorderSide(
              color: context.theme.appColors.primaryAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class TextEditorToolbar extends StatelessWidget {
  const TextEditorToolbar({
    super.key,
    required QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryBackground,
      ),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              TextEditorImageButton(_controller),
              SizedBox(width: 8),
              TextEditorBoldButton(_controller),
              SizedBox(width: 8),
              TextEditorItalicButton(_controller),
              SizedBox(width: 8),
              TextEditorHeading1Button(_controller),
              SizedBox(width: 8),
              TextEditorUlButton(_controller),
              SizedBox(width: 8),
              TextEditorQuoteButton(_controller),
              SizedBox(width: 8),
              TextEditorDividerButton(_controller),
            ],
          ),
        ],
      ),
    );
  }
}
