// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';

class ListLoader extends StatelessWidget {
  const ListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListItemsLoadingState(
      itemsCount: 7,
      separatorHeight: 12.0.s,
      itemHeight: 60.0.s,
      padding: EdgeInsets.zero,
      listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
    );
  }
}
