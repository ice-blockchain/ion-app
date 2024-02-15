import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/search/hooks/use_node_focused.dart';
import 'package:ice/app/components/search/hooks/use_text_changed.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class Search extends HookWidget {
  const Search({
    super.key,
    required this.onTextChanged,
    this.loading = false,
  });

  final Function(String) onTextChanged;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final FocusNode focusNode = useFocusNode();

    final ValueNotifier<bool> showClear = useState(false);
    final ValueNotifier<bool> focused = useNodeFocused(focusNode);

    useTextChanged(
      searchController,
      onTextChanged: (String text) {
        onTextChanged(text);
        showClear.value = text.isNotEmpty;
      },
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 40.0.s,
            child: TextField(
              focusNode: focusNode,
              // focusNode: _focusNode,
              style: context.theme.appTextThemes.body.copyWith(
                color: context.theme.appColors.primaryText,
              ),
              cursorColor: context.theme.appColors.primaryAccent,
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 11.0.s,
                  vertical: 11.0.s,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.appColors.primaryBackground,
                  ),
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                hintText: context.i18n.search_placeholder,
                hintStyle: context.theme.appTextThemes.body.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12.0.s, right: 6.0.s),
                  child: ImageIcon(
                    AssetImage(Assets.images.icons.iconFieldSearch.path),
                    color: context.theme.appColors.tertararyText,
                    size: 16.0.s,
                  ),
                ),
                suffixIcon: loading
                    ? Image.asset(
                        Assets.images.icons.iconFieldIceloader.path,
                        width: 20.0.s,
                        height: 20.0.s,
                      )
                    : showClear.value
                        ? ClearButton(onPressed: () => searchController.clear())
                        : null,
                prefixIconConstraints: const BoxConstraints(),
                filled: true,
                fillColor: context.theme.appColors.primaryBackground,
              ),
              controller: searchController,
            ),
          ),
        ),
        if (focused.value) CancelButton(onPressed: () => focusNode.unfocus()),
      ],
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(12.0.s, 0, 0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(0, 40.0.s),
          padding: EdgeInsets.symmetric(horizontal: 12.0.s),
        ),
        child: Text(
          context.i18n.button_cancel,
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.primaryAccent),
        ),
      ),
    );
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        Assets.images.icons.iconFieldClearall.path,
        width: 20.0.s,
        height: 20.0.s,
      ),
    );
  }
}
