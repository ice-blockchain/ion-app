import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_article/views/pages/create_article_modal/hooks/use_font_type.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button_send/actions_toolbar_button_send.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_single_image_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';
import "package:markdown_quill/markdown_quill.dart";

class CreatePostModal extends HookWidget {
  const CreatePostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final _textEditorController = useRef(
      QuillController.basic(),
    ).value;

    final isDocumentEmpty = useState(true);
    final (fontType, setFontType) = useFontType();

    final _textEditorListener = useCallback(() {
      isDocumentEmpty.value = _textEditorController.document.isEmpty();

      final style = _textEditorController.getSelectionStyle();

      if (style.attributes.containsKey(Attribute.bold.key)) {
        setFontType(FontType.bold);
      } else if (style.attributes.containsKey(Attribute.italic.key)) {
        setFontType(FontType.italic);
      } else {
        setFontType(FontType.regular);
      }
    }, []);

    useEffect(() {
      _textEditorController.addListener(_textEditorListener);
      return () {
        _textEditorController.dispose();
      };
    }, []);

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_post_modal_title),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Avatar(
                          size: 30.0.s,
                          imageUrl:
                              'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                        ),
                        SizedBox(width: 10.0.s),
                        Expanded(
                          child: TextEditor(
                            _textEditorController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              HorizontalSeparator(),
              ScreenSideOffset.small(
                child: ActionsToolbar(
                  actions: [
                    ActionsToolbarButton(
                      icon: Assets.svg.iconGalleryOpen,
                      onPressed: () {
                        _addSingleImageBlock(_textEditorController);
                      },
                    ),
                    ActionsToolbarButton(
                      icon: Assets.svg.iconPostPoll,
                      onPressed: () => {},
                    ),
                    ActionsToolbarButton(
                      icon: Assets.svg.iconPostRegulartextOff,
                      iconSelected: Assets.svg.iconPostRegulartextOn,
                      onPressed: () {
                        _textEditorController
                          ..formatSelection(Attribute.clone(Attribute.bold, null))
                          ..formatSelection(Attribute.clone(Attribute.italic, null));
                      },
                      selected: fontType == FontType.regular,
                    ),
                    ActionsToolbarButton(
                      icon: Assets.svg.iconPostBoldtextOff,
                      iconSelected: Assets.svg.iconPostBoldtextOn,
                      onPressed: () {
                        _textEditorController
                          ..formatSelection(Attribute.clone(Attribute.italic, null))
                          ..formatSelection(Attribute.bold);
                      },
                      selected: fontType == FontType.bold,
                    ),
                    ActionsToolbarButton(
                      icon: Assets.svg.iconPostItalictextOff,
                      iconSelected: Assets.svg.iconPostItalictextOn,
                      onPressed: () {
                        _textEditorController
                          ..formatSelection(Attribute.clone(Attribute.bold, null))
                          ..formatSelection(Attribute.italic);
                      },
                      selected: fontType == FontType.italic,
                    ),
                  ],
                  trailing: ActionsToolbarButtonSend(
                    enabled: !isDocumentEmpty.value,
                    onPressed: () {
                      String markdown = _convertToMarkdown(_textEditorController);
                      log(markdown);
                      context.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _convertToMarkdown(QuillController _textEditorController) {
    final markdown = DeltaToMarkdown(
      customEmbedHandlers: {
        TextEditorSingleImageBuilder().key: (embed, out) {
          out.write('![image](${embed.value.data})');
        },
      },
    ).convert(_textEditorController.document.toDelta());
    return markdown;
  }

  void _addSingleImageBlock(QuillController _textEditorController) {
    final index = _textEditorController.selection.baseOffset;
    _textEditorController.replaceText(
      index,
      0, // No text to delete
      TextEditorSingleImageEmbed.image("https://picsum.photos/600/300"),
      TextSelection.collapsed(
          offset: _textEditorController.document.length), // Move cursor to the end of the document
    );
    //add a new line after the image embed
    _textEditorController.replaceText(
      index + 1,
      0,
      "\n",
      TextSelection.collapsed(offset: _textEditorController.document.length),
    );
  }
}
