import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_search_page/hooks/use_go_back_on_blur.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class FeedSearchNavigation extends HookWidget {
  const FeedSearchNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    useOnInit(focusNode.requestFocus);
    useGoBackOnBlur(focusNode: focusNode);

    return ScreenSideOffset.small(
      child: Row(
        children: [
          Expanded(
            child: SearchInput(
              focusNode: focusNode,
              onTextChanged: (String st) {},
            ),
          ),
        ],
      ),
    );
  }
}
