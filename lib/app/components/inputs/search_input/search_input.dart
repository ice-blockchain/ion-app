import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/hooks/use_text_changed.dart';
import 'package:ice/app/components/inputs/search_input/components/cancel_button.dart';
import 'package:ice/app/components/inputs/search_input/components/search_clear_button.dart';
import 'package:ice/app/components/inputs/search_input/hooks/use_node_focused.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class SearchInput extends HookWidget {
  const SearchInput({
    required this.onTextChanged,
    super.key,
    this.loading = false,
    this.onCancelSearch,
    this.defaultValue = '',
  });

  static double get height => 40.0.s;

  final void Function(String) onTextChanged;
  final VoidCallback? onCancelSearch;
  final bool loading;
  final String defaultValue;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: defaultValue);
    final focusNode = useFocusNode();

    final showClear = useState(false);
    final focused = useNodeFocused(focusNode);

    useTextChanged(
      controller: searchController,
      onTextChanged: (String text) {
        onTextChanged(text);
        showClear.value = text.isNotEmpty;
      },
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: height,
            child: TextField(
              focusNode: focusNode,
              style: context.theme.appTextThemes.body.copyWith(
                color: context.theme.appColors.primaryText,
              ),
              cursorColor: context.theme.appColors.primaryAccent,
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                contentPadding: EdgeInsets.all(11.0.s),
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
                  child: Assets.images.icons.iconFieldSearch.icon(
                    color: context.theme.appColors.tertararyText,
                    size: 18.0.s,
                  ),
                ),
                suffixIcon: loading
                    ? Padding(
                        padding: EdgeInsets.all(12.0.s),
                        child: Assets.images.icons.iconFieldIceloader
                            .icon(size: 20.0.s),
                      )
                    : showClear.value
                        ? SearchClearButton(
                            onPressed: searchController.clear,
                          )
                        : null,
                prefixIconConstraints: const BoxConstraints(),
                filled: true,
                fillColor: context.theme.appColors.primaryBackground,
              ),
              controller: searchController,
            ),
          ),
        ),
        if (focused.value)
          SearchCancelButton(
            onPressed: () {
              onCancelSearch?.call();
              focusNode.unfocus();
            },
          ),
      ],
    );
  }
}
