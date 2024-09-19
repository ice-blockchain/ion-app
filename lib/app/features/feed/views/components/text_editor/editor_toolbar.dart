import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_poll_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_single_image_block.dart';

class TextEditorToolbar extends HookWidget {
  const TextEditorToolbar({
    super.key,
    required QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    final activeStyle = useState<Style>(Style());
    useEffect(() {
      final listener = () {
        final style = _controller.getSelectionStyle();
        activeStyle.value = style;
      };
      _controller.addListener(listener);
      return () {
        _controller.removeListener(listener);
      };
    }, []);

    return Column(
      children: [
        Text(activeStyle.value.attributes.toString()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //heading 1 icon button
            Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.h1);
                  },
                  icon: Icon(
                    Icons.looks_one,
                  ),
                ),
                //heading 2 icon button
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.h2);
                  },
                  icon: Icon(Icons.looks_two),
                ),
                //heading 3 icon button
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.h3);
                  },
                  icon: Icon(Icons.looks_3),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                //bold icon button
                IconButton(
                  color: activeStyle.value.attributes.containsKey(Attribute.bold.key)
                      ? Colors.blue
                      : Colors.black,
                  onPressed: () {
                    final styles = _controller.getSelectionStyle();

                    //toggle

                    if (styles.attributes.containsKey(Attribute.bold.key)) {
                      _controller.formatSelection(Attribute.clone(Attribute.bold, null));
                    } else {
                      _controller.formatSelection(Attribute.bold);
                    }
                  },
                  icon: Icon(
                    Icons.format_bold,
                  ),
                ),
                //italic icon button
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.italic);
                  },
                  icon: Icon(Icons.format_italic),
                ),
              ],
            ),

            //bulleted list icon button
            Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.ul);
                  },
                  icon: Icon(Icons.format_list_bulleted),
                ),
                //numbered list icon button
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.ol);
                  },
                  icon: Icon(Icons.format_list_numbered),
                ),
              ],
            ),
            // quote icon button
            Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.blockQuote);
                  },
                  icon: Icon(Icons.format_quote),
                ),
                //code icon button
                IconButton(
                  onPressed: () {
                    _controller.formatSelection(Attribute.codeBlock);
                  },
                  icon: Icon(Icons.code),
                ),
              ],
            ),

            //image icon button
            Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // _controller.formatSelection(Attribute.image);

                    final index = _controller.selection.baseOffset;

                    // Insert the custom image block
                    _controller.replaceText(
                      index,
                      0, // No text to delete
                      TextEditorSingleImageEmbed.image(
                          "https://images.unsplash.com/photo-1504384764586-bb4cdc1707b0?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      TextSelection.collapsed(
                          offset: _controller
                              .document.length), // Move cursor to the end of the document
                    );
                    //add a new line after the image
                    _controller.replaceText(
                      index + 1,
                      0,
                      "\n",
                      TextSelection.collapsed(offset: _controller.document.length),
                    );
                  },
                  icon: Icon(Icons.image),
                ),
                //surveys icon button
                IconButton(
                  onPressed: () {
                    final index = _controller.selection.baseOffset;

                    _controller.replaceText(
                      index,
                      0,
                      TextEditorPollBlockEmbed(),
                      TextSelection.collapsed(offset: _controller.document.length),
                    );

                    _controller.replaceText(
                      index + 1,
                      0,
                      "\n",
                      TextSelection.collapsed(offset: _controller.document.length),
                    );
                  },
                  icon: Icon(Icons.poll),
                ),
              ],
            ),
            //mention icon button
            IconButton(
              onPressed: () {
                // _controller.formatSelection(Attribute.mention);
              },
              icon: Icon(Icons.alternate_email),
            ),
            //hashtag icon button
            IconButton(
              onPressed: () {
                // _controller.formatSelection(Attribute.hashtag);
              },
              icon: Icon(Icons.tag),
            ),
            //clear
            IconButton(
              onPressed: () {
                _controller.clear();
              },
              icon: Icon(Icons.format_clear),
            ),
          ],
        ),
      ],
    );
  }
}
