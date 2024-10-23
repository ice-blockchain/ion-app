// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class SearchNavigation extends HookConsumerWidget {
  const SearchNavigation({
    required this.query,
    required this.loading,
    required this.onSubmitted,
    required this.onTextChanged,
    super.key,
  });

  final String query;

  final bool loading;

  final void Function(String query) onSubmitted;
  final void Function(String text) onTextChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final searchController = useTextEditingController();
    useOnInit(focusNode.requestFocus);

    useOnInit(
      () {
        // Sync query and text input value after setting a query from the history
        if (searchController.text != query) {
          searchController.text = query;
        }
      },
      [query],
    );

    return ScreenSideOffset.small(
      child: Row(
        children: [
          Expanded(
            child: SearchInput(
              loading: loading,
              controller: searchController,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onCancelSearch: () {
                context.pop();
              },
              onSubmitted: (String query) {
                context.pop();
                if (query.isNotEmpty) {
                  onSubmitted(query);
                }
              },
              onTextChanged: (String text) {
                if (query != text) {
                  onTextChanged(text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
