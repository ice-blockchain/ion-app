import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class Search extends StatefulWidget {
  const Search({
    super.key,
    required this.onTextChanged,
    required this.onClearText,
  });

  final Function(String) onTextChanged;
  final VoidCallback onClearText;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void _onClearTapped() {
    _controller.clear();
    widget.onClearText();
  }

  void _onCancelTapped() {
    _focusNode.unfocus();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 42,
              child: CupertinoTextField(
                focusNode: _focusNode,
                decoration: BoxDecoration(
                  color: context.theme.appColors.primaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                controller: _controller,
                placeholder: context.i18n.search_placeholder,
                placeholderStyle: context.theme.appTextThemes.body.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: ImageIcon(
                    AssetImage(Assets.images.search.path),
                    color: context.theme.appColors.tertararyText,
                    size: 14,
                  ),
                ),
                clearButtonMode: OverlayVisibilityMode.editing,
                onChanged: widget.onTextChanged,
                suffixMode: OverlayVisibilityMode.editing,
                suffix: _controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: _onClearTapped,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(
                            CupertinoIcons.clear_circled,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          if (_isFocused)
            CupertinoButton(
              onPressed: _onCancelTapped,
              child: Text(
                context.i18n.button_cancel,
                style: context.theme.appTextThemes.caption
                    .copyWith(color: context.theme.appColors.primaryAccent),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
