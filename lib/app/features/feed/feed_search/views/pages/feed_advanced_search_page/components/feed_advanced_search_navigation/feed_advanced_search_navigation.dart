// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_button/navigation_button.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedAdvancedSearchNavigation extends HookConsumerWidget {
  const FeedAdvancedSearchNavigation({
    required this.query,
    super.key,
  });

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    useOnInit(
      () {
        searchController.text = query;
      },
      [query],
    );

    return ScreenSideOffset.small(
      child: Row(
        children: [
          NavigationButton(
            onPressed: context.pop,
            icon: Assets.svg.iconBackArrow.icon(
              color: context.theme.appColors.primaryText,
            ),
          ),
          SizedBox(width: 12.0.s),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FeedSimpleSearchRoute(query: query).push<void>(context),
              child: IgnorePointer(
                child: SearchInput(controller: searchController, suffix: const SizedBox.shrink()),
              ),
            ),
          ),
          SizedBox(width: 12.0.s),
          NavigationButton(
            onPressed: () {
              FeedSearchFiltersRoute().push<void>(context);
            },
            icon: Assets.svg.iconButtonManagecoin.icon(
              color: context.theme.appColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
